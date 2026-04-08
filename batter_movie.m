clear all
clc

%バッターのスティックピクチャ作成

%ファイルの入力
[rdf_name,prd]=uigetfile('*.json','入力ファイルの指定','multiselect','off');
cd(prd);
rdf_name=cellstr(rdf_name);
loopsize=size(rdf_name,2);
%HB_24=[0 0;0.432 0;0.432 0.09;0.216 0.09;0 0];
HB_62=[0 0 0;-0.216 0.216 0;-0.216 0.432 0;0.216 0.432 0;0.216 0.216 0;0 0 0];
%HB_46=[0 0;0.216 0.045;0.216 0.09;-0.216 0.09;-0.216 0.045;0 0];
L_box=[-1.566 1.126 0;-0.366 1.126 0;-0.366 -0.694 0;-1.566 -0.694 0;-1.566 1.126 0];
R_box=[1.566 1.126 0;0.366 1.126 0;0.366 -0.694 0;1.566 -0.694 0;1.566 1.126 0];
L_box2=[-1.566 -0.03;-0.366 -0.03;-0.366 0.12;-1.566 0.12];
R_box2=[1.566 -0.03;0.366 -0.03;0.366 0.12;1.566 0.12];
bat_graph=[-0.1524 0.033;0.15 0.033;0.1524 0.027;0.1524 -0.027;0.15 -0.033;-0.1524 -0.033];
zone=[-0.216 0.5;-0.216 0.9;0.216 0.9;0.216 0.5;-0.215 0.5];

formatspec='%.1f';
% 入力ダイアログのプロンプトメッセージを定義
% prompt = {'体重は？'};
% title1 = '変数の入力';
% answer = inputdlg(prompt, title1);
BM=85;
mass_ratio(1:8)=[0.069 0.489 0.027 0.016 0.006 0.11 0.051 0.011];
m_segment(1:8)=mass_ratio(1:8)*BM;
radius_ratio(1:9)=[0.467 0.260 0.278 0.545 0.274 0.273 0.207 0.352 0.167]; %頭　上腕　前腕　手　大腿　下腿　足　屈伸　回旋
I_bat=0.047;
I=[0.047 0 0;0 0.047 0;0 0 0];
bat_mass=0.88;

tic

    rdfname=char(rdf_name);
    s=readstruct(rdfname);

    a=fieldnames(s.samples); %sampleデータの中身を確認
   
   
    %詳細情報
    inning=s.sequences.inning;
    topbottom_s=s.sequences.half;
    %batter=s.batter;
    count=[s.summary.score.count.balls.plateAppearance s.summary.score.count.strikes.plateAppearance s.summary.score.outs.inning];
    %pitcher=s.pitcher;
    vel_imp=[];
    original_date=s.createdAtDateTime;
    delimiter='T';
    date=strtok(original_date,delimiter);

    if topbottom_s==1
       topbottom='top';
    else
        topbottom='bottom';
    end

    %プレイヤーの格納
    players=s.details.players;
    [dx5 dy5]=size(players);
    for p=1:dy5
        player_name(p)=s.details.players(p).fullName;
        player_position(p)=s.details.players(p).role.name;
        player_ID(p)=s.details.players(p).role.id;
        player_hand(p)=s.details.players(p).handedness.batting;
    end

    batter_num=find(player_position(1:dy5)=="Batter");
    pitcher_num=find(player_position(1:dy5)=="Pitcher");

    batter=s.details.players(batter_num).fullName;
    pitcher=s.details.players(pitcher_num).fullName;
    batterside=s.details.players(batter_num).handedness.batting;

    %figure用の文字列作成
    wdw_inning=num2str(inning);
    wdw_count=num2str(count);
    wdw_name=[date wdw_inning topbottom batter wdw_count];
    wdw_name2=join(wdw_name);

    %ボール速度の格納
    vel_ball(1,1:3)=s.samples.ball(3).vel(1,1:3);
    ball_vel=(sqrt((vel_ball(1,1)).^2+(vel_ball(1,2)).^2+(vel_ball(1,3)).^2))*3.6;

     %イベントの格納
    events=s.events;
    [dx4 dy4]=size(s.events);
    for e=1:dy4
        event_type(e)=s.events(e).type;
    end
    %イベント番号の格納
    pitch=find(event_type(1:dy4)=="Pitch");
    during=find(event_type(1:dy4)=="Hit");


    %ボール速度の格納
    ball_vel=s.events(pitch).start.speed.kph;

    %duringがない場合
     if isempty(during)
    before_velocity=[NaN NaN NaN];%インパクト直前の投球速度
    sweetspot_speed=NaN;%芯のスピード
    sweetspot_velocity=[NaN NaN NaN];%芯の速度
    impact_speed=NaN;%インパクトポイントのスピード
    impact_velocity=[NaN NaN NaN];%インパクトポイントの速度
    ball_position=[NaN NaN NaN];%インパクト直前のボール座標
    contact=[NaN NaN NaN];%バットとボールのインパクト座標
    deviation=[NaN NaN];%芯とインパクト位置の関係
    exit_speed=NaN;%打球スピード
    exit_direction=[NaN NaN];%打球方向 
    squred_up=NaN;

    %beforeがない場合
    elseif ~isempty(during) && ~isfield(s.events,'before')
    before_velocity=[NaN NaN NaN];%インパクト直前の投球速度
    sweetspot_speed=NaN;%芯のスピード
    sweetspot_velocity=[NaN NaN NaN];%芯の速度
    impact_speed=NaN;%インパクトポイントのスピード
    impact_velocity=[NaN NaN NaN];%インパクトポイントの速度
    ball_position=[NaN NaN NaN];%インパクト直前のボール座標
    contact=[NaN NaN NaN];%バットとボールのインパクト座標
    deviation=[NaN NaN];%芯とインパクト位置の関係
    exit_speed=NaN;%打球スピード
    exit_direction=[NaN NaN];%打球方向 
    squred_up=NaN;

    else
    before_velocity=s.events(during).before.velocity(1,1:3); %インパクト直前の投球速度
    sweetspot_speed=s.events(during).before.bat.sweetSpot.speed.kph;%芯のスピード
    sweetspot_velocity=s.events(during).before.bat.sweetSpot.velocity(1,1:3);%芯の速度
    impact_speed=s.events(during).before.bat.impactPoint.speed.kph;%インパクトポイントのスピード
    impact_velocity=s.events(during).before.bat.impactPoint.velocity(1,1:3);%インパクトポイントの速度
    ball_position=s.events(during).during.position(1,1:3);%インパクト直前のボール座標
    contact=s.events(during).during.bat.contactPoint.position(1,1:3);%バットとボールのインパクト座標
    deviation=s.events(during).during.bat.sweetSpot.deviation(1,1:2);%芯とインパクト位置の関係
    exit_speed=s.events(during).start.speed.kph;%打球スピード
    exit_direction=s.events(during).start.angle(1,1:2);%打球方向
    squred_up=exit_speed/(1.2*impact_speed+0.2*ball_vel)*100;
    end


    if (a(2,1)=="bat") %batデータがあるデータのみ分析をする
    batdata=s.samples.bat;
    %batterside=s.batterSIde;
    balldata=s.samples.ball;

    %数を数える
    [dx dy] =size(batdata);
    [dx1 dy1]=size(balldata);
    [dx3 dy3]=size(s.samples.people);
    rel=0;
    hit=0;

     %投球座標の格納
    for b1=1:dy1
        ball_event(b1)=s.samples.ball(b1).event;
        ball_time(b1)=s.samples.ball(b1).time;
    end

    rel=find(ball_event(1:dy1)=='Peak',1);
    hit=find(ball_event(1:dy1)=='Hit');
    rel_t=ball_time(rel);
    hit_t=ball_time(hit);
    x=rel-1; %forのための係数
    
    ball=0;
    for b=4:13
        ball(b-3,1:3)=s.samples.ball(b).pos(1,1:3);
    end


    %ボール軌道の近似式
    pxy=polyfit(ball(:,2),ball(:,1),2);
    pyz=polyfit(ball(:,2),ball(:,3),2);
    %xyの軌道
    xxy=-1.5:0.25:15;
    yxy=polyval(pxy,xxy);
    %yzの軌道
    xyz=-1.5:0.25:15;
    yyz=polyval(pyz,xyz);

    ball_traj=[(yxy)' (xxy)' (yyz)'];

    ratio=1.024:-0.004:0.76;
    yxy2=yxy.*ratio;

    %打者の骨格データの検索
    %idとフレームレートを格納
    for sd=1:dy3
        skelton_data(sd,1:2)=[s.samples.people(sd).role.id s.samples.people(sd).system.targetFrameRate];
    end
    
    %idとフレームレートで検索
    bd1(1:dy3,1)=skelton_data(1:dy3,1)+skelton_data(1:dy3,2);
    bd=find(bd1==310);

    jointdata=s.samples.people(bd).joints;
    [dx2 dy2]=size(jointdata);

    %バタワースフィルター
    [fb faa]=butter(4,15/(300/2));

    %身体座標の格納
    % if (s.samples.people(13).system.targetFrameRate==300)
    for f=1:dy2
    time(f,1)=s.samples.people(bd).joints(f).time(1,1);
    %足座標の格納
    lbt9(f,1:3)=s.samples.people(bd).joints(f).lBigToe(1,1:3); %左親指
    lst9(f,1:3)=s.samples.people(bd).joints(f).lSmallToe(1,1:3); %左子指
    lh9(f,1:3)=s.samples.people(bd).joints(f).lHeel(1,1:3); %左踵
    lank9(f,1:3)=s.samples.people(bd).joints(f).lAnkle(1,1:3); %左足首
    rbt9(f,1:3)=s.samples.people(bd).joints(f).rBigToe(1,1:3); %右親指
    rst9(f,1:3)=s.samples.people(bd).joints(f).rSmallToe(1,1:3); %右小指
    rh9(f,1:3)=s.samples.people(bd).joints(f).rHeel(1,1:3); %右踵
    rank9(f,1:3)=s.samples.people(bd).joints(f).rAnkle(1,1:3); %右足首
    %膝・股関節まわり
    rkn9(f,1:3)=s.samples.people(bd).joints(f).rKnee(1,1:3); %右膝
    lkn9(f,1:3)=s.samples.people(bd).joints(f).lKnee(1,1:3); %左膝
    rhp9(f,1:3)=s.samples.people(bd).joints(f).rHip(1,1:3); %右股関節
    lhp9(f,1:3)=s.samples.people(bd).joints(f).lHip(1,1:3); %左股関節
    
    %肩・頭まわり
    rshol9(f,1:3)=s.samples.people(bd).joints(f).rShoulder(1,1:3); %右肩
    lshol9(f,1:3)=s.samples.people(bd).joints(f).lShoulder(1,1:3); %左肩
    neck9(f,1:3)=s.samples.people(bd).joints(f).neck(1,1:3); %首
    relb9(f,1:3)=s.samples.people(bd).joints(f).rElbow(1,1:3); %右肘
    lelb9(f,1:3)=s.samples.people(bd).joints(f).lElbow(1,1:3); %左肘
    rwst9(f,1:3)=s.samples.people(bd).joints(f).rWrist(1,1:3); %右手首
    lwst9(f,1:3)=s.samples.people(bd).joints(f).lWrist(1,1:3); %左手首
    rear9(f,1:3)=s.samples.people(bd).joints(f).rEar(1,1:3); %右耳
    lear9(f,1:3)=s.samples.people(bd).joints(f).lEar(1,1:3); %左耳
    rt9(f,1:3)=s.samples.people(bd).joints(f).rThumb(1,1:3); %右親指
    lt9(f,1:3)=s.samples.people(bd).joints(f).lThumb(1,1:3); %左親指
    rp9(f,1:3)=s.samples.people(bd).joints(f).rPinky(1,1:3); %右小指
    lp9(f,1:3)=s.samples.people(bd).joints(f).lPinky(1,1:3); %左小指
    end

    lbt=filtfilt(fb,faa,lbt9);
    lst=filtfilt(fb,faa,lst9);
    lh=filtfilt(fb,faa,lh9);
    lank=filtfilt(fb,faa,lank9);
    rbt=filtfilt(fb,faa,rbt9);
    rst=filtfilt(fb,faa,rst9);
    rh=filtfilt(fb,faa,rh9);
    rank=filtfilt(fb,faa,rank9);
    rkn=filtfilt(fb,faa,rkn9);
    lkn=filtfilt(fb,faa,lkn9);
    rhp=filtfilt(fb,faa,rhp9);
    lhp=filtfilt(fb,faa,lhp9);
    rshol=filtfilt(fb,faa,rshol9);
    lshol=filtfilt(fb,faa,lshol9);
    neck=filtfilt(fb,faa,neck9);
    relb=filtfilt(fb,faa,relb9);
    lelb=filtfilt(fb,faa,lelb9);
    rwst=filtfilt(fb,faa,rwst9);
    lwst=filtfilt(fb,faa,lwst9);
    rear=filtfilt(fb,faa,rear9);
    lear=filtfilt(fb,faa,lear9);
    rt=filtfilt(fb,faa,rt9);
    lt=filtfilt(fb,faa,lt9);
    rp=filtfilt(fb,faa,rp9);
    lp=filtfilt(fb,faa,lp9);
 
    %batデータの格納
    for k=1:dy
    event(k)=batdata(k).event;
    battime(k,1)=batdata(k).time;
    bathead9(k,1:3)=batdata(k).head.pos(1,1:3);
    batgrip9(k,1:3)=batdata(k).handle.pos(1,1:3);
    end
    
    [fb_bat faa_bat]=butter(4,15/(300/2));
    bathead=filtfilt(fb,faa,bathead9);
    batgrip=filtfilt(fb_bat,faa_bat,batgrip9);
    
    %バット用インパクト位置の検索
    imp=find(event(2:dy)=='Hit');
    imp_time=battime(imp+1,1);
    frame=0;
    for t=1:dy2
    if (time(t)<=imp_time)
       frame=frame+1;
    end
    end
    %for文を回す際のパラメーター バットデータと身体データの一致
    bat_body_diff=frame-imp;
    start_diff=imp-200;
    body_start=start_diff+bat_body_diff;
       
    %重心を算出する
              % %バット
              clear g_bat;
              g_bat(:,1:3)=(0.67)*bathead(:,1:3)+(1-0.67)*batgrip(:,1:3);

    
   
   
    
    headvel(1,1:3)=[0 0 0];
    vel_grip(1,1)=0;
    vel_grip(1,1)=0;
    bat_av(dy,1)=0;
    bat_av(dy,1)=0;
    %headvel(dy-1,1:3)=[0 0 0];
    headvel(dy,1:3)=[0 0 0];
    AV_bat(1,1)=0;
    for j=2:dy-2
        headvel(j,1:3)=(bathead(j+1,1:3)-bathead(j-1,1:3))*150;
        gripvel(j,1:3)=(batgrip(j+1,1:3)-batgrip(j-1,1:3))*150;
        vel_head(j,1)=sqrt((headvel(j,1))^2+(headvel(j,2))^2+(headvel(j,3))^2);
        vel_grip(j,1)=sqrt((gripvel(j,1))^2+(gripvel(j,2))^2+(gripvel(j,3))^2);
        % bat_av(j,1:3)=cross(vec_bat(j,1:3),(vec_bat(j+1,1:3)-vec_bat(j-1,1:3)))/l_bat(j,1)/l_bat(j,1)*150;
        % bat_anglev(j,1)=(acos((dot(vec_bat(j+1,1:3),vec_bat(j-1,1:3)))/l_bat(j,1)/l_bat(j,1)))*150;
    end

    fc1=0;
    fc2=0;
    %バット用インパクト位置の検索
    imp=find(event(2:dy)=='Hit');
    
    %足をプロットするためのフレーム数を決める
    for fc=1:dy2
    if (time(fc) <=rel_t)
      fc1=fc1+1;
    end
    
    if (time(fc) <=hit_t)
        fc2=fc2+1;
    end
    end
    %動画for用の変数
    m=fc2-fc1+1;
    m1=imp-m;

    %インパクト時のバットヘッドスピード
    if (imp==1)
        vel_imp=NaN;

    elseif (vel_head(imp-1)>47.0)
        vel_imp=(vel_head(imp-2))*3.6;
        swing_angle=(atan(headvel(imp-2,3)/sqrt((headvel(imp-2,2)).^2+(headvel(imp-2,1)).^2)))*180/pi;
        s1=num2str(vel_imp,formatspec);
        s2=num2str(swing_angle,formatspec);
        s3=num2str(ball_vel,formatspec);

    else
        vel_imp=(vel_head(imp-1))*3.6;
        swing_angle=(atan(headvel(imp-1,3)/sqrt((headvel(imp-1,2)).^2+(headvel(imp-1,1)).^2)))*180/pi;
        s1=num2str(vel_imp,formatspec);
        s2=num2str(swing_angle,formatspec);
        s3=num2str(ball_vel,formatspec);
    end
    %19行のifの続
    else
        
    end %ifのend 



% 動画の設定
videoName = batter;  % 出力ファイル名
videoObj = VideoWriter(videoName,'MPEG-4');  % VideoWriterオブジェクトを作成
videoObj.FrameRate = 30;  % フレームレートを設定
open(videoObj);  % ビデオファイルを開く

% 入力ダイアログのプロンプトメッセージを定義
prompt = {'水平角 (一塁側から：90,三塁側から-90):', '挙上角 (上から：90):','必要秒数(最大2秒)'};
title1 = '変数の入力';
dims = [1 35]; % ダイアログの入力フィールドのサイズ（行と幅）


% 入力ダイアログを表示
answer = inputdlg(prompt, title1, dims);

% 入力を数値に変換
if ~isempty(answer)  % ユーザーが入力をキャンセルしなかった場合
    hor = str2double(answer{1});
    ele = str2double(answer{2});
    timelen =str2double(answer{3});
    starttime=timelen*300;
   
    
    % % 入力値を表示
    % disp(['変数1: ', num2str(var1)]);
    % disp(['変数2: ', num2str(var2)]);
    % disp(['変数3: ', num2str(var3)]);
else
    disp('入力がキャンセルされました。');
end

% アニメーションを作成
figure;
hold on;
grid on;
xlabel('内外角方向');
ylabel('投手-捕手方向');
zlabel('高さ');
title('Batting Movie');
axis([-2 2 -1.5 2 0 2]);  % 軸の範囲
% 視点の初期角度設定
%左打者は-90°
view(hor,ele); 
axis equal;

% フレームごとにプロット
for i = 1:m-1
    % プロットをリセット
    clf;
    hold on;
    grid on;
    axis([-2 2 -1.5 2 0 2]);  % 軸の範囲を固定
    xlabel('内外角方向');
    ylabel('投手-捕手方向');
    zlabel('高さ');
    title('スティックピクチャのアニメーション');
    axis equal;
    
    
    
    % 各座標を結ぶ
    %左小指
    plot3([lst(i+fc1,1), lank(i+fc1,1)], [lst(i+fc1,2), lank(i+fc1,2)], [lst(i+fc1,3), lank(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左親指
    plot3([lbt(i+fc1,1), lank(i+fc1,1)], [lbt(i+fc1,2), lank(i+fc1,2)], [lbt(i+fc1,3), lank(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左踵
    plot3([lh(i+fc1,1), lank(i+fc1,1)], [lh(i+fc1,2), lank(i+fc1,2)], [lh(i+fc1,3), lank(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左下腿
    plot3([lank(i+fc1,1), lkn(i+fc1,1)], [lank(i+fc1,2), lkn(i+fc1,2)], [lank(i+fc1,3), lkn(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左大腿
    plot3([lkn(i+fc1,1), lhp(i+fc1,1)], [lkn(i+fc1,2), lhp(i+fc1,2)], [lkn(i+fc1,3), lhp(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右小指
    plot3([rst(i+fc1,1), rank(i+fc1,1)], [rst(i+fc1,2), rank(i+fc1,2)], [rst(i+fc1,3), rank(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右親指
    plot3([rbt(i+fc1,1), rank(i+fc1,1)], [rbt(i+fc1,2), rank(i+fc1,2)], [rbt(i+fc1,3), rank(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右踵
    plot3([rh(i+fc1,1), rank(i+fc1,1)], [rh(i+fc1,2), rank(i+fc1,2)], [rh(i+fc1,3), rank(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右下腿
    plot3([rank(i+fc1,1), rkn(i+fc1,1)], [rank(i+fc1,2), rkn(i+fc1,2)], [rank(i+fc1,3), rkn(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右大腿
    plot3([rkn(i+fc1,1), rhp(i+fc1,1)], [rkn(i+fc1,2), rhp(i+fc1,2)], [rkn(i+fc1,3), rhp(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %両大腿
    plot3([lhp(i+fc1,1), rhp(i+fc1,1)], [lhp(i+fc1,2), rhp(i+fc1,2)], [lhp(i+fc1,3), rhp(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左体幹
    plot3([lshol(i+fc1,1), lhp(i+fc1,1)], [lshol(i+fc1,2), lhp(i+fc1,2)], [lshol(i+fc1,3), lhp(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %両肩
    plot3([lshol(i+fc1,1), rshol(i+fc1,1)], [lshol(i+fc1,2), rshol(i+fc1,2)], [lshol(i+fc1,3), rshol(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右体幹
    plot3([rshol(i+fc1,1), rhp(i+fc1,1)], [rshol(i+fc1,2), rhp(i+fc1,2)], [rshol(i+fc1,3), rhp(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左上腕
    plot3([lshol(i+fc1,1), lelb(i+fc1,1)], [lshol(i+fc1,2), lelb(i+fc1,2)], [lshol(i+fc1,3), lelb(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左前腕
    plot3([lelb(i+fc1,1), lwst(i+fc1,1)], [lelb(i+fc1,2), lwst(i+fc1,2)], [lelb(i+fc1,3), lwst(i+fc1,3)], ...
          "color",[1 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右上腕
    plot3([rshol(i+fc1,1), relb(i+fc1,1)], [rshol(i+fc1,2), relb(i+fc1,2)], [rshol(i+fc1,3), relb(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右前腕
    plot3([relb(i+fc1,1), rwst(i+fc1,1)], [relb(i+fc1,2), rwst(i+fc1,2)], [relb(i+fc1,3), rwst(i+fc1,3)], ...
          "color",[0 0 1], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %左耳
    plot3([neck(i+fc1,1), lear(i+fc1,1)], [neck(i+fc1,2), lear(i+fc1,2)], [neck(i+fc1,3), lear(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %右耳
    plot3([neck(i+fc1,1), rear(i+fc1,1)], [neck(i+fc1,2), rear(i+fc1,2)], [neck(i+fc1,3), rear(i+fc1,3)], ...
          "color",[0 1 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    %バット
    plot3([bathead(i+m1,1), batgrip(i+m1,1)], [bathead(i+m1,2), batgrip(i+m1,2)], [bathead(i+m1,3), batgrip(i+m1,3)], ...
          "color",[0 0 0], 'LineWidth', 2, 'MarkerSize', 10);
    hold on
    plot3(HB_62(:,1),HB_62(:,2),HB_62(:,3),"Color",[0.7 0.7 0.7],"LineWidth",2.0);
    hold on
    plot3(L_box(:,1),L_box(:,2),L_box(:,3),"Color",[0.7 0.7 0.7],"LineWidth",2.0);
    hold on
    plot3(R_box(:,1),R_box(:,2),R_box(:,3),"Color",[0.7 0.7 0.7],"LineWidth",2.0);
    hold on
    plot3(ball_traj(:,1),ball_traj(:,2),ball_traj(:,3),'o-',"Color",[0 1 1],"LineWidth",2.0);
    hold on

    % カメラアングルを設定
    view(hor, ele);  % 動的に視点を変更
    %azimuth = 90;  % 水平方向の角度を少しずつ回転
    
    
    % フレームを動画に追加
    frame = getframe(gcf);  % 現在の図をキャプチャ
    writeVideo(videoObj, frame);  % キャプチャしたフレームを動画に追加
    
    pause(0.1);  % 短い遅延を挿入してアニメーションを表示
end

% ビデオファイルを閉じる
close(videoObj);  % ファイルの保存を完了

disp('アニメーション動画が生成されました！');