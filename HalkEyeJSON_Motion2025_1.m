clear
clc
%clf

profile on

list=dir('*.json');
StartFileNo = 1;


for No = StartFileNo:length(list)

clearvars -except No values_array2 list
clc

S = readstruct(list(No).name);

    try
        H = length([S.events.type]);
        % 以下、通常の処理
        % ...
    catch
        continue; % 次のループへ移行
    end

% [S.events.type]内の'Pitch'位置がまちまちなので検索
%H = length([S.events.type]);
P(1,1:H) = [S.events.type];
PNo = find(contains(P, 'Pitch'), 1 );
playID = {S.sequences.reference.mlb.playId};

DateTimeStr = S.sequences.reference.mlb.startTime;
dt = datetime(DateTimeStr, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z', 'TimeZone', 'UTC');
dtJST = dt;
dtJST.TimeZone = 'Asia/Tokyo';

D = datestr(dtJST, 'yyyy-mm-dd--HH-MM-SS');
DDate = datestr(dtJST, 'yyyy/mm/dd');


%% ここから身体動作
%SamplesのPitcher行数を抽出
SP = length(S.samples.people);

PC = 0;

for i = 1 : SP
   if  S.samples.people(i).role.name == "Pitcher" && S.samples.people(i).system.targetFrameRate == 300
   PC = i;
   break;  % Pitcherが見つかったらループを抜ける
   end
end

%Runnerがいるかどうかを確認
%0が走者なし、1が走者あり

Run1 = 0;
Run2 = 0;
Run3 = 0;

for i = 1 : SP

if S.samples.people(i).role.name == "RunnerOnFirst"
    Run1 = 1;
elseif S.samples.people(i).role.name == "RunnerOnSecond"
    Run2 = 1;
elseif S.samples.people(i).role.name == "RunnerOnThird"
    Run3 = 1;
end
end

%Player listのPitcher行数を抽出
DP = length(S.details.players);

for i = 1 : DP
   if  S.details.players(i).role.name == "Pitcher" 
   LoPitcher = i;
   else
   end
end

%Player listからPitcherNameとPThrowsを抽出
PName = S.details.players(LoPitcher).fullName;
PThrows = S.details.players(LoPitcher).handedness.throwing;

if PC > 0

T = struct('time', {S.samples.people(PC).joints.time});
BRframe = 601;

neck = cell(length(S.samples.people(PC).joints), 1);
noze = cell(length(S.samples.people(PC).joints), 1);
midHip = cell(length(S.samples.people(PC).joints), 1);
BackEye = cell(length(S.samples.people(PC).joints), 1);
BackEar = cell(length(S.samples.people(PC).joints), 1);
BackShoulder = cell(length(S.samples.people(PC).joints), 1);
BackElbow = cell(length(S.samples.people(PC).joints), 1);
BackWrist = cell(length(S.samples.people(PC).joints), 1);
BackThumb = cell(length(S.samples.people(PC).joints), 1);
BackPinky = cell(length(S.samples.people(PC).joints), 1);
BackHip = cell(length(S.samples.people(PC).joints), 1);
BackKnee = cell(length(S.samples.people(PC).joints), 1);
BackAnkle = cell(length(S.samples.people(PC).joints), 1);
BackBigToe = cell(length(S.samples.people(PC).joints), 1);
BackSmallToe = cell(length(S.samples.people(PC).joints), 1);
BackHeel = cell(length(S.samples.people(PC).joints), 1);
LeadEye = cell(length(S.samples.people(PC).joints), 1);
LeadEar = cell(length(S.samples.people(PC).joints), 1);
LeadShoulder = cell(length(S.samples.people(PC).joints), 1);
LeadElbow = cell(length(S.samples.people(PC).joints), 1);
LeadWrist = cell(length(S.samples.people(PC).joints), 1);
LeadThumb = cell(length(S.samples.people(PC).joints), 1);
LeadPinky = cell(length(S.samples.people(PC).joints), 1);
LeadHip = cell(length(S.samples.people(PC).joints), 1);
LeadKnee = cell(length(S.samples.people(PC).joints), 1);
LeadAnkle = cell(length(S.samples.people(PC).joints), 1);
LeadBigToe = cell(length(S.samples.people(PC).joints), 1);
LeadSmallToe = cell(length(S.samples.people(PC).joints), 1);
LeadHeel = cell(length(S.samples.people(PC).joints), 1);



neck(:,1) = {S.samples.people(PC).joints(:).neck};
nose(:,1) = {S.samples.people(PC).joints(:).nose};
midHip(:,1) = {S.samples.people(PC).joints(:).midHip};



if PThrows  == "Right" 
        BackEye(:,1) = {S.samples.people(PC).joints(:).rEye};
        BackEar(:,1) = {S.samples.people(PC).joints(:).rEar};
        BackShoulder(:,1) = {S.samples.people(PC).joints(:).rShoulder};
        BackElbow(:,1) = {S.samples.people(PC).joints(:).rElbow};
        BackWrist(:,1) = {S.samples.people(PC).joints(:).rWrist};
        BackThumb(:,1) = {S.samples.people(PC).joints(:).rThumb};
        BackPinky(:,1) = {S.samples.people(PC).joints(:).rPinky};
        BackHip(:,1) = {S.samples.people(PC).joints(:).rHip};
        BackKnee(:,1) = {S.samples.people(PC).joints(:).rKnee};
        BackAnkle(:,1) = {S.samples.people(PC).joints(:).rAnkle};
        BackBigToe(:,1) = {S.samples.people(PC).joints(:).rBigToe};
        BackSmallToe(:,1) = {S.samples.people(PC).joints(:).rSmallToe};
        BackHeel(:,1) = {S.samples.people(PC).joints(:).rHeel};

        LeadEye(:,1) = {S.samples.people(PC).joints(:).lEye};
        LeadEar(:,1) = {S.samples.people(PC).joints(:).lEar};
        LeadShoulder(:,1) = {S.samples.people(PC).joints(:).lShoulder};
        LeadElbow(:,1) = {S.samples.people(PC).joints(:).lElbow};
        LeadWrist(:,1) = {S.samples.people(PC).joints(:).lWrist};
        LeadThumb(:,1) = {S.samples.people(PC).joints(:).lThumb};
        LeadPinky(:,1) = {S.samples.people(PC).joints(:).lPinky};
        LeadHip(:,1) = {S.samples.people(PC).joints(:).lHip};
        LeadKnee(:,1) = {S.samples.people(PC).joints(:).lKnee};
        LeadAnkle(:,1) = {S.samples.people(PC).joints(:).lAnkle};
        LeadBigToe(:,1) = {S.samples.people(PC).joints(:).lBigToe};
        LeadSmallToe(:,1) = {S.samples.people(PC).joints(:).lSmallToe};
        LeadHeel(:,1) = {S.samples.people(PC).joints(:).lHeel};

elseif PThrows == "Left" 

        BackEye(:,1) = {S.samples.people(PC).joints(:).lEye};
        BackEar(:,1) = {S.samples.people(PC).joints(:).lEar};
        BackShoulder(:,1) = {S.samples.people(PC).joints(:).lShoulder};
        BackElbow(:,1) = {S.samples.people(PC).joints(:).lElbow};
        BackWrist(:,1) = {S.samples.people(PC).joints(:).lWrist};
        BackThumb(:,1) = {S.samples.people(PC).joints(:).lThumb};
        BackPinky(:,1) = {S.samples.people(PC).joints(:).lPinky}; 
        BackHip(:,1) = {S.samples.people(PC).joints(:).lHip};
        BackKnee(:,1) = {S.samples.people(PC).joints(:).lKnee};
        BackAnkle(:,1) = {S.samples.people(PC).joints(:).lAnkle};
        BackBigToe(:,1) = {S.samples.people(PC).joints(:).lBigToe};
        BackSmallToe(:,1) = {S.samples.people(PC).joints(:).lSmallToe};
        BackHeel(:,1) = {S.samples.people(PC).joints(:).lHeel};

        LeadEye(:,1) = {S.samples.people(PC).joints(:).rEye};
        LeadEar(:,1) = {S.samples.people(PC).joints(:).rEar};
        LeadShoulder(:,1) = {S.samples.people(PC).joints(:).rShoulder};
        LeadElbow(:,1) = {S.samples.people(PC).joints(:).rElbow};
        LeadWrist(:,1) = {S.samples.people(PC).joints(:).rWrist};
        LeadThumb(:,1) = {S.samples.people(PC).joints(:).rThumb};
        LeadPinky(:,1) = {S.samples.people(PC).joints(:).rPinky};
        LeadHip(:,1) = {S.samples.people(PC).joints(:).rHip};
        LeadKnee(:,1) = {S.samples.people(PC).joints(:).rKnee};
        LeadAnkle(:,1) = {S.samples.people(PC).joints(:).rAnkle};
        LeadBigToe(:,1) = {S.samples.people(PC).joints(:).rBigToe};
        LeadSmallToe(:,1) = {S.samples.people(PC).joints(:).rSmallToe};
        LeadHeel(:,1) = {S.samples.people(PC).joints(:).rHeel};

end   

    noseN = cell2mat(nose);
    neckN = cell2mat(neck);
    midHipN = cell2mat(midHip);
    BackEyeN = cell2mat(BackEye);
    BackEarN = cell2mat(BackEar);
    BackShoulderN = cell2mat(BackShoulder);
    BackElbowN = cell2mat(BackElbow);
    BackWristN = cell2mat(BackWrist);
    BackThumbN = cell2mat(BackThumb);
    BackPinkyN = cell2mat(BackPinky);
    BackHipN = cell2mat(BackHip);
    BackKneeN = cell2mat(BackKnee);
    BackAnkleN = cell2mat(BackAnkle);
    BackBigToeN = cell2mat(BackBigToe);
    BackSmallToeN = cell2mat(BackSmallToe);
    BackHeelN = cell2mat(BackHeel);
    LeadEyeN = cell2mat(LeadEye);
    LeadEarN = cell2mat(LeadEar);
    LeadShoulderN = cell2mat(LeadShoulder);
    LeadElbowN = cell2mat(LeadElbow);
    LeadWristN = cell2mat(LeadWrist);
    LeadThumbN = cell2mat(LeadThumb);
    LeadPinkyN = cell2mat(LeadPinky);
    LeadHipN = cell2mat(LeadHip);
    LeadKneeN = cell2mat(LeadKnee);
    LeadAnkleN = cell2mat(LeadAnkle);
    LeadBigToeN = cell2mat(LeadBigToe);
    LeadSmallToeN = cell2mat(LeadSmallToe);
    LeadHeelN = cell2mat(LeadHeel);
    midShoulderN = (BackShoulderN + LeadShoulderN) / 2;
    BallN = (BackPinkyN + BackThumbN) / 2;

   % ローパスフィルタの係数を設定
    filter_orderN = 5;  % フィルター次数
   % 1に近づけるとフィルターが薄く、0に近づけるとフィルターが濃くなる
    cutoff_frequencyN = 0.05;  % カットオフ周波数
   % ローパスフィルタを設計
    [b, a] = butter(filter_orderN, cutoff_frequencyN);

    Nsignals = [neckN, noseN, midHipN, midShoulderN, BackEyeN, BackEarN, BackShoulderN, BackThumbN, BackPinkyN, BackHipN, BackKneeN, BackAnkleN, BackBigToeN, BackSmallToeN, BackHeelN, LeadEyeN, LeadEarN, LeadShoulderN, LeadThumbN, LeadPinkyN, LeadHipN, LeadKneeN, LeadAnkleN, LeadBigToeN, LeadSmallToeN, LeadHeelN];
    filtered_Nsignals = filtfilt(b, a, Nsignals);


    s_neckN = filtered_Nsignals(:, 1:3);
    s_noseN = filtered_Nsignals(:, 4:6);
    s_midHipN = filtered_Nsignals(:, 7:9);
    s_midShoulderN = filtered_Nsignals(:, 10:12);
    s_BackEyeN = filtered_Nsignals(:, 13:15);
    s_BackEarN = filtered_Nsignals(:, 16:18);
    s_BackShoulderN = filtered_Nsignals(:, 19:21);
    s_BackThumbN = filtered_Nsignals(:, 22:24);
    s_BackPinkyN = filtered_Nsignals(:, 25:27);
    s_BackHipN = filtered_Nsignals(:, 28:30);
    s_BackKneeN = filtered_Nsignals(:, 31:33);
    s_BackAnkleN = filtered_Nsignals(:, 34:36);
    s_BackBigToeN = filtered_Nsignals(:, 37:39);
    s_BackSmallToeN = filtered_Nsignals(:, 40:42);
    s_BackHeelN = filtered_Nsignals(:, 43:45);
    s_LeadEyeN = filtered_Nsignals(:, 46:48);
    s_LeadEarN = filtered_Nsignals(:, 49:51);
    s_LeadShoulderN = filtered_Nsignals(:, 52:54);
    s_LeadThumbN = filtered_Nsignals(:, 55:57);
    s_LeadPinkyN = filtered_Nsignals(:, 58:60);
    s_LeadHipN = filtered_Nsignals(:, 61:63);
    s_LeadKneeN = filtered_Nsignals(:, 64:66);
    s_LeadAnkleN = filtered_Nsignals(:, 67:69);
    s_LeadBigToeN = filtered_Nsignals(:, 70:72);
    s_LeadSmallToeN = filtered_Nsignals(:, 73:75);
    s_LeadHeelN = filtered_Nsignals(:, 76:78);
    
   % ローパスフィルタの係数を設定
    filter_orderN2 = 5;  % フィルター次数
   % 1に近づけるとフィルターが薄く、0に近づけるとフィルターが濃くなる
    cutoff_frequencyN2 = 0.15;  % カットオフ周波数
   % ローパスフィルタを設計
    [b2, a2] = butter(filter_orderN2, cutoff_frequencyN2);

    Nsignals2 = [BackElbowN, BackWristN, LeadElbowN, LeadWristN, BallN];
    filtered_Nsignals2 = filtfilt(b, a, Nsignals2);
 
    s_BackElbowN = filtered_Nsignals2(:, 1:3);
    s_BackWristN = filtered_Nsignals2(:, 4:6);
    s_LeadElbowN = filtered_Nsignals2(:, 7:9);
    s_LeadWristN = filtered_Nsignals2(:, 10:12);
    s_BallN = filtered_Nsignals2(:, 13:15);

%Back股関節からのベクトルを算出    
    BackHpBS = s_BackHipN - s_BackShoulderN;
    BackHpKn = s_BackHipN - s_BackKneeN;
    LeadHpBS = s_LeadHipN - s_LeadShoulderN;
    LeadHpKn = s_LeadHipN - s_LeadKneeN;
%ひざからのベクトルを算出    
    BackKnHp = s_BackKneeN - s_BackHipN;
    BackKnAn = s_BackKneeN - s_BackAnkleN;
    LeadKnHp = s_LeadKneeN - s_LeadHipN;
    LeadKnAn = s_LeadKneeN - s_LeadAnkleN;
% 単位ベクトルに変換
    BackKnHp_norm = BackKnHp / norm(BackKnHp);
    BackKnAn_norm = BackKnAn / norm(BackKnAn);
    LeadKnHp_norm = LeadKnHp / norm(LeadKnHp);
    LeadKnAn_norm = LeadKnAn / norm(LeadKnAn);
% 膝関節角度が伸展方向に大きくなるように調整
% 矢状面の法線ベクトルを仮定 (例: y軸が前後方向なら xz平面での動き)
% %     normal_vector = [0, 1, 0];  % 矢状面（前後方向）の法線
% % % v1とv2の外積を計算
% %     cross_productLeadKnHp = cross(LeadKnHp, LeadKnAn);
%足首からのベクトルを算出    
    BackAnKn = s_BackAnkleN - s_BackKneeN;
    BackAnST = s_BackAnkleN - s_BackSmallToeN;
    LeadAnKn = s_LeadAnkleN - s_LeadKneeN;
    LeadAnST = s_LeadAnkleN - s_LeadSmallToeN;
%肘からのベクトルを算出    
    BackElWr = s_BackElbowN - s_BackWristN;
        BackWrEl = s_BackWristN - s_BackElbowN;
    BackElSh = s_BackElbowN - s_BackShoulderN;
%骨盤左→右のベクトルを算出    
    LHtoBH = s_LeadHipN - s_BackHipN;
%胸郭左→右のベクトルを算出    
    LStoBS = s_LeadShoulderN - s_BackShoulderN;



DataLength = length([S.samples.people(PC).joints.time]);

%% forの前に格納サイズを指定した方が良いらしい
AngleBackHip = zeros(DataLength, 1);
AngleLeadHip = zeros(DataLength, 1);
AngleBackKnee = zeros(DataLength, 1);
AngleLeadKnee = zeros(DataLength, 1);
AngleBackAnkle = zeros(DataLength, 1);
AngleLeadAnkle = zeros(DataLength, 1);
AngleElbow = zeros(DataLength, 1);
AnglePelvis = zeros(DataLength, 1);
AngleThorax = zeros(DataLength, 1);
AngleUpperarm = zeros(DataLength, 1);
dotPelvis = zeros(DataLength, 1);
normPelvisA = zeros(DataLength, 1);
normPelvisB = zeros(DataLength, 1);
theta_radP = zeros(DataLength, 1);
theta_degP = zeros(DataLength, 1);
dotThorax = zeros(DataLength, 1);
normThoraxA = zeros(DataLength, 1);
normThoraxB = zeros(DataLength, 1);
theta_radT = zeros(DataLength, 1);
theta_degT = zeros(DataLength, 1);
dotUpperarm = zeros(DataLength, 1);
normUpperarmA = zeros(DataLength, 1);
normUpperarmB = zeros(DataLength, 1);
theta_radU = zeros(DataLength, 1);
theta_degU = zeros(DataLength, 1);
BallDistance = zeros(DataLength, 1);


for n = 1 : DataLength    

%%股関節角度
%内積で角度を算出
   AngleBackHip(n,:) = rad2deg(acos(dot(BackHpBS(n,:), BackHpKn(n,:))/(norm(BackHpBS(n,:))*norm(BackHpKn(n,:)))));
   AngleLeadHip(n,:) = rad2deg(acos(dot(LeadHpBS(n,:), LeadHpKn(n,:))/(norm(LeadHpBS(n,:))*norm(LeadHpKn(n,:)))));
 
%%膝関節角度
%内積で角度を算出
   AngleBackKnee(n,:) = rad2deg(acos(dot(BackKnHp(n,:), BackKnAn(n,:))/(norm(BackKnHp(n,:))*norm(BackKnAn(n,:)))));
   AngleLeadKnee(n,:) = rad2deg(acos(dot(LeadKnHp(n,:), LeadKnAn(n,:))/(norm(LeadKnHp(n,:))*norm(LeadKnAn(n,:)))));

%%足関節角度
%内積で角度を算出
   AngleBackAnkle(n,:) = rad2deg(acos(dot(BackAnKn(n,:), BackAnST(n,:))/(norm(BackAnKn(n,:))*norm(BackAnST(n,:)))));
   AngleLeadAnkle(n,:) = rad2deg(acos(dot(LeadAnKn(n,:), LeadAnST(n,:))/(norm(LeadAnKn(n,:))*norm(LeadAnST(n,:)))));

%%肘関節角度
%内積で角度を算出
   AngleElbow(n,:) = rad2deg(acos(dot(BackElWr(n,:), BackElSh(n,:))/(norm(BackElWr(n,:))*norm(BackElSh(n,:)))));

%%骨盤角度
%atan2で角度を算出; 投捕方向と一致で0°、閉じるとマイナス、正対で90°
    if PThrows == "Right"   
        AnglePelvis(n,:) = atan2d(LHtoBH(n,1),LHtoBH(n,2)*-1);
    elseif PThrows == "Left"
        AnglePelvis(n,:) = -1 * atan2d(LHtoBH(n,1),LHtoBH(n,2)*-1);
    end

    %AngularVelocityPelvis = diff(AnglePelvis)/(1/300);

%%胸郭角度
%atan2で角度を算出; 投捕方向と一致で0°、閉じるとマイナス、正対で90°
    if PThrows == "Right"   
        AngleThorax(n,:) = atan2d(LStoBS(n,1),LStoBS(n,2)*-1);    
    elseif PThrows == "Left"
        AngleThorax(n,:) = -1 * atan2d(LStoBS(n,1),LStoBS(n,2)*-1);    
    end

    %AngularVelocityThorax = diff(AngleThorax)/(1/300);

%%上腕回転角度
%atan2で角度を算出; 
    if PThrows == "Right"   
        AngleUpperarm(n,:) = -1 * atan2d(BackElSh(n,1),BackElSh(n,2));    
    elseif PThrows == "Left"
        AngleUpperarm(n,:) = atan2d(BackElSh(n,1),BackElSh(n,2));    
    end

    %AngularVelocityUpperarm = diff(AngleUpperarm)/(1/300);    
end


for n = 2 : DataLength - 1 
    
%%骨盤角度
    dotPelvis(n,:) = dot(LHtoBH(n-1,:), LHtoBH(n+1,:));
    normPelvisA(n,:) = norm(LHtoBH(n-1,:));
    normPelvisB(n,:) = norm(LHtoBH(n+1,:));

    theta_radP(n,:) = acos(dotPelvis(n,:) / (normPelvisA(n,:)  * normPelvisB(n,:)));
    theta_degP(n,:) = rad2deg(theta_radP(n,:));

%%胸郭角度
    dotThorax(n,:) = dot(LStoBS(n-1,:), LStoBS(n+1,:));
    normThoraxA(n,:) = norm(LStoBS(n-1,:));
    normThoraxB(n,:) = norm(LStoBS(n+1,:));

    theta_radT(n,:) = acos(dotThorax(n,:) / (normThoraxA(n,:)  * normThoraxB(n,:)));
    theta_degT(n,:) = rad2deg(theta_radT(n,:));


%%上腕回転角度
    dotUpperarm(n,:) = dot(BackElSh(n-1,:), BackElSh(n+1,:));
    normUpperarmA(n,:) = norm(BackElSh(n-1,:));
    normUpperarmB(n,:) = norm(BackElSh(n+1,:));

    theta_radU(n,:) = acos(dotUpperarm(n,:) / (normUpperarmA(n,:)  * normUpperarmB(n,:)));
    theta_degU(n,:) = rad2deg(theta_radU(n,:));  

%%ボール移動距離
    BallDistance(n,:) = sqrt(sum((s_BallN(n+1, :) - s_BallN(n-1, :)).^2))/2;
    
end


    AngularVelocityPelvis = (theta_degP/(1/150));
    AngularVelocityThorax = (theta_degT/(1/150));
    AngularVelocityUpperarm = (theta_degU/(1/150));

    [pksAVP,locsAVP] = findpeaks(AngularVelocityPelvis);
    PeakNoAVP = find(BRframe-15>locsAVP(:,1), 1, 'last');
    PeakNoAVP1 = find(BRframe-200>locsAVP(:,1), 1, 'last');
    MaxAVP = max(pksAVP(PeakNoAVP1:PeakNoAVP));
    ColMaxAVP = find(pksAVP == MaxAVP);
    TimeMaxAVP = T(locsAVP(ColMaxAVP));

    [pksAVT,locsAVT] = findpeaks(AngularVelocityThorax);
    PeakNoAVT = find(BRframe-15>locsAVT(:,1), 1, 'last');
    PeakNoAVT1 = find(BRframe-200>locsAVT(:,1), 1, 'last');
    MaxAVT = max(pksAVT(PeakNoAVT1:PeakNoAVT));
    ColMaxAVT = find(pksAVT == MaxAVT);
    TimeMaxAVT = T(locsAVT(ColMaxAVT));

    [pksAVU,locsAVU] = findpeaks(AngularVelocityUpperarm);
    PeakNoAVU = find(BRframe>locsAVU(:,1), 1, 'last');
    PeakNoAVU1 = find(BRframe-50>locsAVU(:,1), 1, 'last');
    MaxAVU = max(pksAVU(PeakNoAVU1:PeakNoAVU));
    ColMaxAVU = find(pksAVU == MaxAVU);
    TimeMaxAVU = T(locsAVU(ColMaxAVU));


    % plot(locs2, pks2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    % hold on



%%胸郭-骨盤角度
    AngleThPe = AnglePelvis - AngleThorax;

    UpDownDistNeckN(1,1) = 0;
    ChangeAnglePelvis(1,1) = 0;


AngleLowerLeg = zeros(DataLength,1); 

for n = 2 : DataLength - 1

%%首の上下動　neck 前後の動き基準
    UpDownDistNeckN(n,1) = s_neckN(n+1,3) - s_neckN(n-1,3);

%%骨盤角度の変化　前後の動き基準
    ChangeAnglePelvis(n,1) = AnglePelvis(n+1,1)-AnglePelvis(n-1,1);

%%下腿角度
  %すでに上にある  LeadAnKn(n,:) = LeadAnkleN(n,:) - LeadKneeN(n,:);
  %atan2で角度を算出; 鉛直方向と一致で0°、閉じるとマイナス、開くとプラス
    if PThrows == "Right"
        AngleLowerLeg(n,:) = rad2deg(atan2(LeadAnKn(n,1),LeadAnKn(n,3)*-1));    
    elseif PThrows == "Left"
        AngleLowerLeg(n,:) = -1 * rad2deg(atan2(LeadAnKn(n,1),LeadAnKn(n,3)*-1));    
    end
end

%%肩関節角度by谷中
    midline = s_midShoulderN - s_midHipN;
    upper_arm = BackElSh;
    fore_arm = s_BackWristN - s_BackElbowN;

    %上腕に垂直な座標系の作成
    %Ux
    Ux_abs=sqrt(upper_arm(:,1).^2+upper_arm(:,2).^2+upper_arm(:,3).^2);
    Ux=upper_arm(:,1:3)./Ux_abs;

    dy2 = length(T);

    upper_v(1,1:3)=[0 0 0];
    upper_v(dy2,1:3)=[0 0 0];
    upper_abs(dy2,1)=1;

    for ir=2:dy2-1
        upper_v(ir,1:3)=upper_arm(ir+1,1:3)-upper_arm(ir-1,1:3);
        upper_abs(ir,1)=sqrt(upper_v(ir,1).^2+upper_v(ir,2).^2+upper_v(ir,3).^2);
    end

    tUy=upper_v(:,1:3)./upper_abs;
    %Uz
    tUz=cross(Ux,tUy);
    Uz_abs=sqrt(tUz(:,1).^2+tUz(:,2).^2+tUz(:,3).^2);
    Uz=tUz(:,1:3)./Uz_abs;
    %Uy
    ttUy=cross(Uz,Ux);
    Uy_abs=sqrt(ttUy(:,1).^2+ttUy(:,2).^2+ttUy(:,3).^2);
    Uy=ttUy(:,1:3)./Uy_abs;

    %上腕座標系に投影した前腕
    Fx=Ux(:,1).*fore_arm(:,1)+Ux(:,2).*fore_arm(:,2)+Ux(:,3).*fore_arm(:,3);
    Fy=Uy(:,1).*fore_arm(:,1)+Uy(:,2).*fore_arm(:,2)+Uy(:,3).*fore_arm(:,3);
    Fz=Uz(:,1).*fore_arm(:,1)+Uz(:,2).*fore_arm(:,2)+Uz(:,3).*fore_arm(:,3);
    F_abs=sqrt(Fx.^2+Fy.^2+Fz.^2);
    %上腕座標系に投影した体幹
    Tx=Ux(:,1).*midline(:,1)+Ux(:,2).*midline(:,2)+Ux(:,3).*midline(:,3);
    Ty=Uy(:,1).*midline(:,1)+Uy(:,2).*midline(:,2)+Uy(:,3).*midline(:,3);
    Tz=Uz(:,1).*midline(:,1)+Uz(:,2).*midline(:,2)+Uz(:,3).*midline(:,3);
    T_abs=sqrt(Tx.^2+Ty.^2+Tz.^2);
    
    %内外旋角度
    AngleShoulderIntExt=acosd(Fx.*Tx+Fy.*Ty+Fz.*Tz./F_abs./T_abs) + 90;


%%ここまで

%各時刻を算出
%%どちらか早いほうを動き出しとする 初期位置より0.03cm動いたら動き出し。

%%%%%

%%動作開始 

%%下肢最大挙上 LeadKnee
    MaxHeightLeadKneeN = max(s_LeadKneeN(:,3));
    ColMaxHeightLeadKneeN = find(s_LeadKneeN(:,3)==MaxHeightLeadKneeN);
    TimeMaxHeightLeadKneeN = T(ColMaxHeightLeadKneeN);

%%移動開始 Neckが下方に始めた時
   % 首の下がり始めpeakのうち、リリースより２つ前＝移動開始を探す
    [pks,locs] = findpeaks(UpDownDistNeckN);
    PeakNo = find(locs(:,1)<BRframe);
    ColNeckDownward = locs(max(PeakNo)-1);
    TimeNeckDownward = T(ColNeckDownward);


%%手首最低　BackWrist
    MinHeightBackWristN = min(s_BackWristN(400:BRframe,3));
    ColMinHeightBackWristN = find(s_BackWristN(:,3)==MinHeightBackWristN);
    TimeMinHeightBackWristN = T(ColMinHeightBackWristN);

%%足離れ始め BackHeelが下肢最大挙上時から5cm動いた
    BHPos = s_BackHeelN(ColMaxHeightLeadKneeN,:); % 初期位置
    MvmtBH = s_BackHeelN - BHPos;
    MvmtBH(:,4) = sqrt(MvmtBH(:,1).^2 + MvmtBH(:,2).^2 + MvmtBH(:,3).^2);

    [pksMvmtBH,locsMvmtBH] = findpeaks(-MvmtBH(:,4));
    PeakMvmtBH = find(locsMvmtBH(:,1)<600);
    ColStartMvmtBH = locsMvmtBH(max(PeakMvmtBH)); 
    TimeStartMvmtBH = T(ColStartMvmtBH);


%%骨盤回り始め LeadHip -> BackHipの投捕方向に対する角度
   %骨盤角度の差分からピーク検出
    [pks2,locs2] = findpeaks(diff(-AnglePelvis));
    PeakNo2 = find(locs2(:,1)<(BRframe-60));
    ColPelvisOpen = locs2(max(PeakNo2));
    TimePelvisOpen = T(ColPelvisOpen);


%%胸郭回り始め 
   %胸郭角度の差分からピーク検出
    [pks3,locs3] = findpeaks(diff(-AngleThorax));
    PeakNo3 = find(locs3(:,1)<(BRframe-30));
    ColThoraxOpen = locs3(max(PeakNo3));
    TimeThoraxOpen = T(ColThoraxOpen);

 
%%肘最大挙上（コッキング）BR前の最大挙上の前のピーク
    [pks4,locs4] = findpeaks(s_BackElbowN(:,3));
    PeakNo4 = find((locs4(:,1)<BRframe));
    ColMaxHeightBackElbow = locs4(max(PeakNo4));
    TimeMaxHeightBackElbow = T(ColMaxHeightBackElbow);

    MaxHeightBackElbow = BackElbowN(ColMaxHeightBackElbow,3);


    % 初期位置
    s_LeadBigToeNBR = mean(s_LeadBigToeN(600:610,:));
    s_LeadSmallToeNBR = mean(s_LeadSmallToeN(600:610,:));
    s_LeadHeelNBR = mean(s_LeadHeelN(600:610,:));

    MvmtBigToe = s_LeadBigToeN - s_LeadBigToeNBR;
    MvmtSmallToe = s_LeadSmallToeN - s_LeadSmallToeNBR;
    MvmtHeel = s_LeadHeelN - s_LeadHeelNBR;

    MvmtBigToe(:,4) = sqrt(MvmtBigToe(:,1).^2 + MvmtBigToe(:,2).^2 + MvmtBigToe(:,3).^2);
    MvmtSmallToe(:,4) = sqrt(MvmtSmallToe(:,1).^2 + MvmtSmallToe(:,2).^2 + MvmtSmallToe(:,3).^2);
    MvmtHeel(:,4) = sqrt(MvmtHeel(:,1).^2 + MvmtHeel(:,2).^2 + MvmtHeel(:,3).^2);

    % 接地の閾値
    LandThreshold = 0.05;

    LandBigToe = find(MvmtBigToe(:,4)<LandThreshold,1);
    LandSmallToe = find(MvmtSmallToe(:,4)<LandThreshold,1);
    LandHeel = find(MvmtHeel(:,4)<LandThreshold,1);

    ColLandFoot = min(min(LandBigToe, LandSmallToe), LandHeel);
    TimeLandFoot = T(ColLandFoot);


%%最大外旋　BR直前に手首-肘のY軸方向の差の最大となったタイミング
    [pks6,locs6] = findpeaks(AngleShoulderIntExt);
    PeakNo6 = find(BRframe>locs6(:,1));
    ColMER = locs6(max(PeakNo6));
    TimeMER = T(ColMER);


%%MERからリリースまでのボール移動距離と曲率



%%リリース  0sec    


%% 角度算出準備
    WrEl = s_BackWristN - s_BackElbowN;
    ElSh = s_BackElbowN - s_BackShoulderN;
    NemH = s_neckN - s_midHipN;

%%最大胸郭-骨盤ねじれ
    [AngleMaxThPe, ColMaxThPe] = max(AngleThPe(ColPelvisOpen:BRframe,1));
    TimeAngleMaxThPe = T(ColMaxThPe+ColPelvisOpen);

%%接地時の各角度
    if PThrows == "Right"   
    AngleBodyAPFC = rad2deg(atan2(NemH(ColLandFoot,3), -NemH(ColLandFoot,2)));
    AngleBodySiFC = rad2deg(atan2(NemH(ColLandFoot,3), -NemH(ColLandFoot,1)));
    
    elseif PThrows == "Left"   
    AngleBodyAPFC = rad2deg(atan2(NemH(ColLandFoot,3), -NemH(ColLandFoot,2)));
    AngleBodySiFC = rad2deg(atan2(NemH(ColLandFoot,3), NemH(ColLandFoot,1))); 
    end

    AnglePelvisFC = AnglePelvis(ColLandFoot);
    AngleThoraxFC = AngleThorax(ColLandFoot);
    AngleThPeFC = AngleThPe(ColLandFoot);
    AngleLeadKneeFC = AngleLeadKnee(ColLandFoot, 1);

    AngleLowerLegFC = AngleLowerLeg(ColLandFoot,:);
    AngleElbowFC = AngleElbow(ColLandFoot,:);
    
    %ここにストライドを
    StrideLeadShoulder = 18.44 - s_LeadShoulderN(ColLandFoot, 2);
    StrideLeadHeel = 18.44 - s_LeadHeelN(ColLandFoot, 2);

    %骨盤高さも
    HeightPelvisFC = s_midHipN(ColLandFoot,3);


%%リリース時の各角度
    if PThrows == "Right"   
    AngleForearmAzimuthBR = rad2deg(atan2(-WrEl(BRframe,2), -WrEl(BRframe,1)));
    AngleForearmElevationBR = rad2deg(atan2(WrEl(BRframe,3), sqrt(WrEl(BRframe,1)^2 + WrEl(BRframe,2)^2)));
    AngleForearmSlot = rad2deg(atan2(WrEl(BRframe,3), -WrEl(BRframe,1)));
    AngleUpperarmAzimuthBR = rad2deg(atan2(-ElSh(BRframe,2), -ElSh(BRframe,1)));
    AngleUpperarmElevationBR = rad2deg(atan2(ElSh(BRframe,3), sqrt(ElSh(BRframe,1)^2 + ElSh(BRframe,2)^2)));
    AngleUpperarmSlot = rad2deg(atan2(ElSh(BRframe,3), -ElSh(BRframe,1)));
    AngleBodyAPBR = rad2deg(atan2(NemH(BRframe,3), -NemH(BRframe,2)));
    AngleBodySiBR = rad2deg(atan2(NemH(BRframe,3), -NemH(BRframe,1)));
    
    elseif PThrows == "Left"   
    AngleForearmAzimuthBR = rad2deg(atan2(-WrEl(BRframe,2), WrEl(BRframe,1)));
    AngleForearmElevationBR = rad2deg(atan2(WrEl(BRframe,3), sqrt(WrEl(BRframe,1)^2 + WrEl(BRframe,2)^2)));
    AngleForearmSlot = rad2deg(atan2(WrEl(BRframe,3), WrEl(BRframe,1)));
    AngleUpperarmAzimuthBR = rad2deg(atan2(-ElSh(BRframe,2), ElSh(BRframe,1)));
    AngleUpperarmElevationBR = rad2deg(atan2(ElSh(BRframe,3), sqrt(ElSh(BRframe,1)^2 + ElSh(BRframe,2)^2)));
    AngleUpperarmSlot = rad2deg(atan2(ElSh(BRframe,3), ElSh(BRframe,1)));
    AngleBodyAPBR = rad2deg(atan2(NemH(BRframe,3), -NemH(BRframe,2)));
    AngleBodySiBR = rad2deg(atan2(NemH(BRframe,3), NemH(BRframe,1))); 
    end

    AnglePelvisBR = AnglePelvis(BRframe);
    AngleThoraxBR = AngleThorax(BRframe);    
    AngleLeadKneeBR = AngleLeadKnee(BRframe);

    AngleLowerLegBR = AngleLowerLeg(BRframe,:);
    AngleElbowBR = AngleElbow(BRframe,:);
    AngleShoulderIntExtBR = AngleShoulderIntExt(BRframe,:);

%%後ろ膝の最大屈曲角度
    MaxFlexAngleBackKnee = min(AngleBackKnee(1:ColLandFoot, 1));

%%肩の最大外旋角度
    MER = AngleShoulderIntExt(ColMER, :);

%%ボールの移動距離
   [pksBD,locsBD] = findpeaks(-BallDistance);
 %加速の始まり（一旦移動が少なくなったところ）からリリースまでの移動距離
   PeakBD = locsBD(find((locsBD(:,1)<BRframe), 1, 'last' ), 1);
   BallDistanceACCStarttoBR = sum(BallDistance(PeakBD:BRframe, 1));

curvatureValues = zeros(BRframe+1, 1);
curvatureValuesHorz = zeros(BRframe+1, 1);
curvatureValuesVert = zeros(BRframe+1, 1);

for n = PeakBD - 1 : BRframe + 1 
    x1 = s_BallN(n-1, 1);
    y1 = s_BallN(n-1, 2);
    z1 = s_BallN(n-1, 3);
        
    x2 = s_BallN(n, 1);
    y2 = s_BallN(n, 2);
    z2 = s_BallN(n, 3);
        
    x3 = s_BallN(n+1, 1);
    y3 = s_BallN(n+1, 2);
    z3 = s_BallN(n+1, 3);
        
   % ベクトル計算
    v1_3d = [x2-x1, y2-y1, z2-z1];
    v2_3d = [x3-x2, y3-y2, z3-z2];
        
   % 外積と内積を使用した曲率近似
    numerator = norm(cross(v1_3d, v2_3d));
    denominator = (norm(v1_3d) * norm(v2_3d))^2;
        
    curvatureValues(n,:) = numerator / denominator;

   % ベクトル計算
    v1_Horz = [x2-x1, y2-y1, 0];
    v2_Horz = [x3-x2, y3-y2, 0];
        
   % 外積と内積を使用した曲率近似
    numeratorHorz = norm(cross(v1_Horz, v2_Horz));
    denominatorHorz = (norm(v1_Horz) * norm(v2_Horz))^2;
        
    curvatureValuesHorz(n,:) = numeratorHorz / denominatorHorz;


   % ベクトル計算
    v1_Vert = [0, y2-y1, z2-z1];
    v2_Vert = [0, y3-y2, z3-z2];
        
   % 外積と内積を使用した曲率近似
    numeratorVert = norm(cross(v1_Vert, v2_Vert));
    denominatorVert = (norm(v1_Vert) * norm(v2_Vert))^2;
        
    curvatureValuesVert(n,:) = numeratorVert / denominatorVert;

end


%曲率平均値
curvature3DMean = mean(curvatureValues(595:599,1));
curvatureHorizontalMean = mean(curvatureValuesHorz(595:599,1));
curvatureVerticalMean = mean(curvatureValuesVert(595:599,1));


%%骨盤中心midHipの速度
   % filter_order = 5;  % フィルター次数
   % 1に近づけるとフィルターが薄く、0に近づけるとフィルターが濃くなる
   % cutoff_frequency = 0.1;  % カットオフ周波数
   % ローパスフィルタを設計
   % [b, a] = butter(filter_order, cutoff_frequency);
   % smoothed_midHipN = filtfilt(b, a, midHipN);
   
    Speed3dmidHip = [diff(-s_midHipN(:,1))./(1/300), diff(-s_midHipN(:,2))./(1/300), diff(s_midHipN(:,3))./(1/300)];
    
    [MaxSpeedmid3dHip, ColMaxSpeed3dmidHip] = max(Speed3dmidHip(1:BRframe,:));
    [MinSpeedmid3dHip, ColMinSpeed3dmidHip] = min(Speed3dmidHip(1:BRframe,:));
    
    TimeMaxSpeed3dmidHipY = T(ColMaxSpeed3dmidHip(1,2));

    SpeedmidHip = sqrt(Speed3dmidHip(:,1).^2 + Speed3dmidHip(:,2).^2 + Speed3dmidHip(:,3).^2);
    [MaxSpeedmidHip, ColMaxSpeedmidHip] = max(SpeedmidHip(1:BRframe,:));

    TimeMaxSpeedmidHip = T(ColMaxSpeedmidHip);

%%出力
%values_array2 = zeros(length(list), 58);


if  TimeLandFoot.time < -0.07 && TimeLandFoot.time > -0.2 && (ColThoraxOpen > ColPelvisOpen)
values_array2(No,:) = [playID, D, "", PName, S.summary.acts.pitch.speed.kph,  TimeMaxHeightLeadKneeN.time, TimeNeckDownward.time, TimeMinHeightBackWristN.time, TimeStartMvmtBH.time, TimeMaxSpeed3dmidHipY.time, TimeMaxSpeedmidHip.time, TimePelvisOpen.time, TimeThoraxOpen.time, TimeMaxHeightBackElbow.time, TimeAngleMaxThPe.time, TimeLandFoot.time, TimeMER.time, MaxHeightBackElbow, MaxFlexAngleBackKnee, MER, StrideLeadHeel, StrideLeadShoulder, HeightPelvisFC, AngleElbowFC, AnglePelvisFC, AngleThoraxFC, AngleThPeFC, AngleLeadKneeFC, AngleLowerLegFC, AngleShoulderIntExtBR, AngleElbowBR, AnglePelvisBR, AngleThoraxBR, AngleLeadKneeBR, AngleLowerLegBR, AngleBodyAPBR, AngleBodySiBR, AngleUpperarmAzimuthBR, AngleUpperarmElevationBR, AngleUpperarmSlot, AngleForearmAzimuthBR, AngleForearmElevationBR, AngleForearmSlot, MaxSpeedmidHip, MaxSpeedmid3dHip(1,2), AngleMaxThPe, TimeMaxAVP.time, TimeMaxAVT.time, TimeMaxAVU.time, MaxAVP, MaxAVT, MaxAVU, BallDistanceACCStarttoBR, curvature3DMean, curvatureHorizontalMean, curvatureVerticalMean, Run1, Run2, Run3, DDate];
elseif TimeLandFoot.time < -0.07 && TimeLandFoot.time > -0.2 %FCが上記条件に当てはまらなかった場合
values_array2(No,:) = [playID, D, "", PName, S.summary.acts.pitch.speed.kph,  TimeMaxHeightLeadKneeN.time, TimeNeckDownward.time, TimeMinHeightBackWristN.time, TimeStartMvmtBH.time, TimeMaxSpeed3dmidHipY.time, TimeMaxSpeedmidHip.time, TimePelvisOpen.time, "", TimeMaxHeightBackElbow.time, TimeAngleMaxThPe.time, TimeLandFoot.time, TimeMER.time, MaxHeightBackElbow, MaxFlexAngleBackKnee, MER, StrideLeadHeel, StrideLeadShoulder, HeightPelvisFC, AngleElbowFC, AnglePelvisFC, AngleThoraxFC, AngleThPeFC, AngleLeadKneeFC, AngleLowerLegFC, AngleShoulderIntExtBR, AngleElbowBR, AnglePelvisBR, AngleThoraxBR, AngleLeadKneeBR, AngleLowerLegBR, AngleBodyAPBR, AngleBodySiBR, AngleUpperarmAzimuthBR, AngleUpperarmElevationBR, AngleUpperarmSlot, AngleForearmAzimuthBR, AngleForearmElevationBR, AngleForearmSlot, MaxSpeedmidHip, MaxSpeedmid3dHip(1,2), AngleMaxThPe, TimeMaxAVP.time, TimeMaxAVT.time, TimeMaxAVU.time, MaxAVP, MaxAVT, MaxAVU, BallDistanceACCStarttoBR, curvature3DMean, curvatureHorizontalMean, curvatureVerticalMean, Run1, Run2, Run3, DDate];
else
values_array2(No,:) = [playID, D, "", PName, S.summary.acts.pitch.speed.kph,  TimeMaxHeightLeadKneeN.time, TimeNeckDownward.time, TimeMinHeightBackWristN.time, TimeStartMvmtBH.time, TimeMaxSpeed3dmidHipY.time, TimeMaxSpeedmidHip.time, TimePelvisOpen.time, "", TimeMaxHeightBackElbow.time, TimeAngleMaxThPe.time, "", TimeMER.time, MaxHeightBackElbow, MaxFlexAngleBackKnee, MER, "", "", "", "", "","", "", "", "", AngleShoulderIntExtBR, AngleElbowBR, AnglePelvisBR, AngleThoraxBR, AngleLeadKneeBR, AngleLowerLegBR, AngleBodyAPBR, AngleBodySiBR, AngleUpperarmAzimuthBR, AngleUpperarmElevationBR, AngleUpperarmSlot, AngleForearmAzimuthBR, AngleForearmElevationBR, AngleForearmSlot, MaxSpeedmidHip, MaxSpeedmid3dHip(1,2), AngleMaxThPe, TimeMaxAVP.time, TimeMaxAVT.time, TimeMaxAVU.time, MaxAVP, MaxAVT, MaxAVU, BallDistanceACCStarttoBR, curvature3DMean, curvatureHorizontalMean, curvatureVerticalMean, Run1, Run2, Run3, DDate];
end


else %ここに空白行を入れる指示

values_array2(No,:) = [playID, D, "", PName, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", Run1, Run2, Run3, DDate];

end

disp(No/length(list)) 

end   % for No = StartFileNo:length(list) の終了


list = dir('*.json');
disp(length(list))