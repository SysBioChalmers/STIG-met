function model = setupModel(model)
% setupModel
% Modifies a model struct to fit human simulation purposes.
% Only allows excreation of Urea (by removing exchange of NH3). Only allows
% excreation of CO2 by removing HCO3. Use concistent reaction directions
% removes duplicate reactions. Adds exchange reactions for free fatty
% acids. 
%   model           A model struct
%   model          	The modifyed model struct
%
%   Avlant Nilsson, 2016-05-16
%
    %revert to old subsystem convention
    for i = 1:length(model.subSystems)
        tmp = model.subSystems{i};
        model.subSystems{i} = tmp{1};
    end

    %standardize met id
    for i = 1:length(model.mets)
        model.mets{i} = ['m' num2str(i)];
    end    
    
    %turn of NH3 excretion
    model = removeRxns(model, {'HMR_9073', 'EX_nh4'}, true);
    
    %turn of HCO3 excretion
    model = removeRxns(model, {'HMR_9078', 'HMR_9079'}, true);
        
%    model = removeDuplicateReactions(model);
    
    %Add maintanance reaction
    lactRxn = createRXNStuct(model, 'human_ATPMaintainance', 'ATP[c] + H2O[c] => ADP[c] + Pi[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',false);
  
    %Add protein pool reaction
    lactRxn = createRXNStuct(model, 'human_proteinPool', '0.0937 alanine[c] + 0.0507 arginine[c] + 0.0799 asparagine[c] + 0.0142 cysteine[c] + 0.1118 glutamine[c] + 0.1831 glycine[c] + 0.0198 histidine[c] + 0.0309 isoleucine[c] + 0.0664 leucine[c] + 0.0571 lysine[c] + 0.0156 methionine[c] + 0.0290 phenylalanine[c] + 0.0853 proline[c] + 0.0491 serine[c] + 0.0402 threonine[c] + 0.0072 tryptophan[c] + 0.0190 tyrosine[c] + 0.0471 valine[c] => human_protein_pool[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);    
 
    %Add DNA pool
    lactRxn = createRXNStuct(model, 'human_DNAPool', '0.3 dAMP[c] + 0.2 dCMP[c] + 0.2 dGMP[c] + 0.3 dTMP[c] => human_DNAPool[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);    
		
    %Add RNA pool
    lactRxn = createRXNStuct(model, 'human_RNAPool', '0.18 AMP[c] + 0.30 CMP[c] + 0.34 GMP[c] + 0.18 UMP[c] => human_RNAPool[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);    
    
    %Add growth maintainanance
    lactRxn = createRXNStuct(model, 'human_GrowthMaintainance', 'ATP[c] + H2O[c] => ADP[c] + Pi[c] + human_growthMaintainance[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);           
    
    %Add TG pool
    lactRxn = createRXNStuct(model, 'human_TGPool', '0.02907 lauric acid[c] + 0.04848 myristic acid[c] + 0.26589 palmitate[c] + 0.03995 stearate[c] + 0.04009 palmitolate[c] + 0.43820 oleate[c] + 0.12712 linoleate[c] + 0.00567 linolenate[c] + 0.00169 dihomo-gamma-linolenate[c] + 0.00206 arachidonate[c] + 0.00024 EPA[c] + 0.00148 DPA[c] + 0.00007 DHA[c] => human_TGPool[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);    
    
    %Add Human biomass
    lactRxn = createRXNStuct(model, 'human_biomass', '1.883 human_protein_pool[c] + 0.0125 human_DNAPool[c] + 0.0296 human_RNAPool[c] + 0.03078 cholesterol[c] + 0.149 glycogen[c] + 2.905 human_TGPool[c] + 96 human_growthMaintainance[c] => human_biomass[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    
    %Add lean mass
    lactRxn = createRXNStuct(model, 'human_leanmass', '6.6 human_protein_pool[c] + 0.03 human_DNAPool[c] + 0.03 human_RNAPool[c] + 0.25 glycogen[c] => biomassLean[c]', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    
    %Add fat mass
    lactRxn = createRXNStuct(model, 'human_fatmass', '3.49 human_TGPool[c] <=> biomassFat[c]', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true);     
    
    %Add transport reactions
    lactRxn = createRXNStuct(model, 'human_biomassTransp', 'human_biomass[c] <=> human_biomass[s]', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    lactRxn = createRXNStuct(model, 'human_biomassExport', 'human_biomass[s] =>', 0, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    lactRxn = createRXNStuct(model, 'human_fatmassTransp', 'biomassFat[c] <=> biomassFat[s]', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    lactRxn = createRXNStuct(model, 'human_fatmassExport', 'biomassFat[s] <=>', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    lactRxn = createRXNStuct(model, 'human_leanmassTransp', 'biomassLean[c] <=> biomassLean[s]', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
    lactRxn = createRXNStuct(model, 'human_leanmassExport', 'biomassLean[s] <=>', -1000, 1000, 'maint');
    model=addRxns(model,lactRxn,3,'c',true); 
		
		
		
		
		
		
		
		
		
    
    
    %Make boundary imbalanced to allow uptake
    [~,boundCompInd] = ismember('x',model.comps);
    boundMets = (model.metComps == boundCompInd);
    model.S(boundMets,:) = 0;
    if isfield(model,'unconstrained')
        model = rmfield(model,'unconstrained');
    end

    %Fix P/O ratio
    model = configureSMatrix(model, -3, 'HMR_6916', 'H+[Mitochondria]');
    model = configureSMatrix(model, 3, 'HMR_6916', 'H+[Inner mitochondria]');

    %Remove leaky Complex IV
    model = removeRxns(model, 'CYOOm3i', true);
    
    %Prevent free PI
    model = removeRxns(model, {'HMR_6330', 'HMR_4865', 'HMR_4862', 'HMR_3971', 'HMR_4940', 'HMR_6331', 'HMR_4870'}, true);
    
    %Prevent ATP from propionate synthesis
    model = removeRxns(model, {'HMR_0153', 'HMR_4459'}, true);   
    
    %Remove reversibility of FAD consuming reactions
    model.lb(findIndex(model.rxns, 'r0701')) = 0;
    model.lb(findIndex(model.rxns, 'RE1519X')) = 0;
    model.lb(findIndex(model.rxns, 'HMR_6911')) = 0;
    model.lb(findIndex(model.rxns, 'HMR_3212')) = 0;
    
    %exchange rxns
    [exchangeRxns,exchangeRxnsIndexes] = getExchangeRxns(model,'both');
    model.exchangeRxns = exchangeRxnsIndexes; 
    

end

