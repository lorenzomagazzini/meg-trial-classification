function [ featurepairs ] = get_featurepairs( features, ntrl )
%[ featurepairs ] = get_featurepairs( features, ntrl )
%   
%   Input:
%       features        struct (only fields of size 1 x ntrl are kept)
%   
%   Output:
%       featurepairs    cell array (P x 3, where P = number of feature pairs)

features_fields = fieldnames(features);
nf = length(features_fields);

plotcount = 0;
featurepairs = [];
feat1index = 0;
for f = 1:nf
    
    if f>feat1index
        
        feat1found = 0;
        count1 = 0;
        while ~istrue(feat1found)
            
            if f+count1 > nf
                return
            end
            
            feat1 = features.(features_fields{f+count1});
            
            if size(feat1,1) == 1 && size(feat1,2) == ntrl
                feat1found = 1;
            else
                count1 = count1+1;
            end
            
        end %while
        
        feat1index = f+count1;
        feat1label = features_fields{feat1index};
        
        
        feat2index = 0;
        for ff = 1:nf
            
            if ff>feat2index
                
                feat2found = 0;
                count2 = 0;
                while ~istrue(feat2found)
                    
                    if feat1index+count2 > nf
                        return
                    end
                    
                    feat2 = features.(features_fields{ff+count2});
                    
                    if size(feat2,1) == 1 && size(feat2,2) == ntrl
                        feat2found = 1;
                        plotcount = plotcount+1;
                    else
                        count2 = count2+1;
                    end
                    
                end %while
                
                feat2index = ff+count2;
                feat2label = features_fields{feat2index};
                
                
                featurepairs{plotcount,1} = [feat1; feat2];
                featurepairs{plotcount,2} = feat1label;
                featurepairs{plotcount,3} = feat2label;
                
            end %if ff
            
        end %ff
        
    end %if f
    
end %f

