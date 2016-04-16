public with sharing class TerritoryTargetingControllerMVN {

    public List<Territory_Targets__c> targets {get;set;}
    public Territory_Targeting_Metrics_MVN__c metric {get;set;}

    public TerritoryTargetingControllerMVN(ApexPages.StandardController stdController) {
        metric = [select Id, Territory__c, Owner.Name, Preselects_Untargeted__c, Calls_Per_Month_Targets__c, Calls_Per_Month_Goals__c, Territory_Name__c,
                        Remaining_Calls_to_Goal__c, Insulin_Market_Coverage__c, OwnerId,
                        A_Starting_Tier_Count__c, A_Deselected__c, A_Selected__c, A_Final_Tier_Counts__c,
                        B_Starting_Tier_Count__c, B_Deselected__c, B_Selected__c, B_Final_Tier_Counts__c,
                        C_Starting_Tier_Count__c, C_Deselected__c, C_Selected__c, C_Final_Tier_Counts__c,
                        D_Starting_Tier_Count__c, D_Deselected__c, D_Selected__c, D_Final_Tier_Counts__c,
                        Champion_Starting_Segment_Count__c, Champion_Deselected__c, Champion_Selected__c, Champion_Final_Segment_Counts__c,
                        Lion_Starting_Segment_Count__c, Lion_Deselected__c, Lion_Selected__c, Lion_Final_Segment_Counts__c,
                        Potential_Starting_Segment_Count__c, Potential_Deselected__c, Potential_Selected__c, Potential_Final_Segment_Counts__c, Selected_Targets__c
                    from Territory_Targeting_Metrics_MVN__c where Id = :stdController.getId()];

        targets = [select Id, Name__c, Primary_Specialty__c, Mailing_Address__c, Selected_Tier__c, Suggested_Tier__c, Insulin_Decile__c, Commercial_Payor__c, Reason__c, Total_Insulin_TRX__c, Dexcom_Decile__c, Rank__c, Party_Id__c
                    from Territory_Targets__c
                    where Territory_Metrics__c = :metric.Id];

        Decimal unselectedCount = 0;
        Decimal suggestedCount = 0;
        Integer suggestedTier = 0;
        Decimal totalInsulinTRX = 0;
        Decimal totalInsulinSelected = 0;

        Integer aCount = 0;
        Integer bCount = 0;
        Integer cCount = 0;
        Integer dCount = 0;

        Integer championCount = 0;
        Integer lionCount = 0;
        Integer potentialCount = 0;

        for(Territory_Targets__c target : targets){
            if(target.Selected_Tier__c != null && target.Selected_Tier__c != ''){
                if(target.Total_Insulin_TRX__c != null){
                    totalInsulinSelected += target.Total_Insulin_TRX__c;
                }
                if(target.Selected_Tier__c == 'A-3'){
                    suggestedTier += 3;
                } else if (target.Selected_Tier__c == 'B-2'){
                    suggestedTier += 2;
                } else if (target.Selected_Tier__c == 'C-1'){
                    suggestedTier += 1;
                } 
            } 
          
            if(target.Total_Insulin_TRX__c != null){
                totalInsulinTRX += target.Total_Insulin_TRX__c;
            }
            
            if(target.Suggested_Tier__c != null && target.Suggested_Tier__c != ''){
                suggestedCount++;
                if(target.Suggested_Tier__c == 'A-3'){
                    aCount++;
                } else if (target.Suggested_Tier__c == 'B-2'){
                    bCount++;
                } else if (target.Suggested_Tier__c == 'C-1'){
                    cCount++;
                } else if(target.Suggested_Tier__c     == 'D-0'){
                    dCount++;
                } 
                if(target.Selected_Tier__c == null || target.Selected_Tier__c == '') {
                    unselectedCount++;
                }
            }

            
        }
        System.debug('SUGGESTED COUNT: ' + suggestedCount);
        System.debug('UNSELECTED COUNT: ' + unselectedCount);
        if(suggestedCount > 0){
            metric.Preselects_Untargeted__c = (unselectedCount / suggestedCount) * 100;
        }
        System.debug('PRESELECTS UNTARGETED' + metric.Preselects_Untargeted__c);

        metric.Calls_Per_Month_Targets__c = suggestedTier;
        if(totalInsulinTRX > 0){
            metric.Insulin_Market_Coverage__c = (totalInsulinSelected / totalInsulinTRX) * 100;
        }
        metric.A_Starting_Tier_Count__c = aCount;
        metric.B_Starting_Tier_Count__c = bCount;
        metric.C_Starting_Tier_Count__c = cCount;
        metric.D_Starting_Tier_Count__c = dCount;
        metric.Champion_Starting_Segment_Count__c = championCount;
        metric.Lion_Starting_Segment_Count__c = lionCount;
        metric.Potential_Starting_Segment_Count__c = potentialCount;

        if(metric.Calls_Per_Month_Goals__c - metric.Calls_Per_Month_Targets__c <= 0){
            metric.Remaining_Calls_to_Goal__c = 0;
        } else {
            metric.Remaining_Calls_to_Goal__c = metric.Calls_Per_Month_Goals__c - metric.Calls_Per_Month_Targets__c;
        }
    }

    public Boolean getIsAdmin(){
        Profile adminProfile = [select Id from Profile where Name = 'System Administrator'];

        if(adminProfile.Id == UserInfo.getProfileId()){
            return true;
        } else {
            return false;
        }
    }

    public PageReference submitTargets(){
        
        Integer aDeselected = 0;
        Integer bDeselected = 0;
        Integer cDeselected = 0;
        Integer dDeselected = 0;
        Integer aSelected = 0;
        Integer bSelected = 0;
        Integer cSelected = 0;
        Integer dSelected = 0;
        Integer championSelected = 0;
        Integer championDeselected = 0;
        Integer lionSelected = 0;
        Integer lionDeselected = 0;
        Integer potentialSelected = 0;
        Integer potentialDeselected = 0;

        for(Territory_Targets__c target : targets){
            System.debug(target);
            //if((target.Suggested_Tier__c == '' || target.Suggested_Tier__c == null) && (target.Selected_Tier__c != null && target.Selected_Tier__c != '')){
            //    if(target.Selected_Tier__c == 'A-3'){
            //        aSelected += 1;
            //    } else if(target.Selected_Tier__c == 'B-2'){
            //        bSelected += 1;
            //    } else if(target.Selected_Tier__c == 'C-1'){
            //        cSelected += 1;
            //    } else if(target.Selected_Tier__c == 'D-0'){
            //        dSelected += 1;
            //    } 
            //} else if((target.Selected_Tier__c == '' || target.Selected_Tier__c == null) && (ntarget.Suggested_Tier__c != null && target.Suggested_Tier__c != '')){
            //    if(target.Suggested_Tier__c == 'A-3'){
            //        aDeselected += 1;
            //    } else if(target.Suggested_Tier__c == 'B-2'){
            //        bDeselected += 1;
            //    } else if(target.Suggested_Tier__c == 'C-1'){
            //        cDeselected += 1;
            //    } else if(target.Suggested_Tier__c == 'D-0'){
            //        dDeselected += 1;
            //    }
            //}

            if(target.Selected_Tier__c != target.Suggested_Tier__c){
                if(target.Suggested_Tier__c == null || target.Suggested_Tier__c == ''){
                } else if(target.Suggested_Tier__c == 'A-3'){
                    aDeselected += 1;
                } else if(target.Suggested_Tier__c == 'B-2'){
                    bDeselected += 1;
                } else if(target.Suggested_Tier__c == 'C-1'){
                    cDeselected += 1;
                } else if(target.Suggested_Tier__c == 'D-0'){
                    dDeselected += 1;
                }

                if(target.Selected_Tier__c == null || target.Selected_Tier__c == ''){
                } else if(target.Selected_Tier__c == 'A-3'){
                    aSelected += 1;
                } else if(target.Selected_Tier__c == 'B-2'){
                    bSelected += 1;
                } else if(target.Selected_Tier__c == 'C-1'){
                    cSelected += 1;
                } else if(target.Selected_Tier__c == 'D-0'){
                    dSelected += 1;
                } 
            }

            if(target.Selected_Tier__c == target.Suggested_Tier__c){
                target.Reason__c = null;
            }
        }

        metric.A_Deselected__c = aDeselected;
        metric.B_Deselected__c = bDeselected;
        metric.C_Deselected__c = cDeselected;
        metric.D_Deselected__c = dDeselected;
        metric.A_Selected__c = aSelected;
        metric.B_Selected__c = bSelected;
        metric.C_Selected__c = cSelected;
        metric.D_Selected__c = dSelected;
        metric.Champion_Selected__c = championSelected;
        metric.Lion_Selected__c = lionSelected;
        metric.Potential_Selected__c = potentialSelected;
        metric.Champion_Deselected__c = championDeselected;
        metric.Lion_Deselected__c = lionDeselected;
        metric.Potential_Deselected__c = potentialDeselected;
        System.debug(metric);
        
        update metric;
        update targets;

        User currentUser = [select Id, Last_Accessed_Targeting_Tool_MVN__c from User where Id = :UserInfo.getUserId()];

        currentUser.Last_Accessed_Targeting_Tool_MVN__c = DateTime.now();

        update currentUser;
        
        PageReference page = new PageReference('/' + metric.Id);

        page.setRedirect(true);
        System.debug(page.getUrl());
        return page;
    }
}