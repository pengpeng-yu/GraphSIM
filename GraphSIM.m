% function GraphSIM_score = GraphSIM(name_fast, name_r, name_d)   
% name_fast: the keypoint resampling of point cloud, generated by demo_fast_make.m
% name_r: reference point cloud
% name_d: distorted point cloud

clear
global name_fast;
global name_r;
global name_d;
% name_fast = ('redandblack10000_4.ply');
% name_r = ('redandblack.ply');
% name_d = ('redandblack_0_0.ply');

tic;
T = 0.001;
%% Load point clouds
pc_fast = pcread(name_fast);
pc_r = pcread(name_r);
pc_d = pcread(name_d);
%% Neighbor Dimension
pc_r_coor = pc_r.Location;
pc_d_coor = pc_d.Location;
pc_fast_coor = pc_fast.Location;

max_x = max(pc_r_coor(:,1)) - min(pc_r_coor(:,1));
max_y = max(pc_r_coor(:,2)) - min(pc_r_coor(:,2));
max_z = max(pc_r_coor(:,3)) - min(pc_r_coor(:,3));
box = [max_x, max_y, max_z];
epsilon = floor(min(box)/10);
r = pc_fast.Count;
sample_LMN = cell(r,1);
%% Radius search
[idx, dit] = rangesearch(pc_r_coor, pc_fast_coor, epsilon);
[idx_d, dit_d] = rangesearch(pc_d_coor, pc_fast_coor, epsilon);

for s = 1:r
    %% Graph creation
    [pointset, center, weight, radius] = graphcreation_radius(pc_r, pc_fast, idx{s,1}, dit{s,1}, s);
    [pointset_d, center_d, weight_d, radius_d] = graphcreation_radius(pc_d, pc_fast, idx_d{s,1}, dit_d{s,1}, s);
    %% Similarity computation 
    feature_LMN = computeSimilarity(pointset, pointset_d, center, center_d, weight, weight_d, T);
    sample_LMN{s,1}=feature_LMN;
end
L=6;M=1;N=1;
%% Compute GraphSIM  
GraphSIM_score=cal_mos(sample_LMN,L,M,N);
fprintf('GraphSIM: %d\n',GraphSIM_score);
toc;
