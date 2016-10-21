PT=5040
ISO=Tight
#for BIN in Eq2 GtrEq2; do
BIN=GtrEq2QCD
BIN=Eq2QCD
BIN=ttbar
BIN=newQCD
BIN=NoScaleEq2
BIN=NoScaleC
DATE=Oct21v2
BIN=NoScaleEq2
BIN=NoScaleGtrEq2
BIN=Oct21Final



rm -r output/htt_cards/
#cp data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV_svFitMass-5040-Tight-ICHEP-${BIN}.root data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV.root
#cp data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV_svFitMass-5040-Tight-ICHEP-${BIN}.root data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV.root
#for BIN in NoScaleGtrEq2 NoScaleEq2; do
#for BIN in NoScaleGtrEq2 Oct14; do
for BIN in Oct21Final; do
    cp data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV_svFitMass-5040-Tight-ICHEP-${BIN}.root data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV.root
    HTT-tt
    pushd output/htt_cards
    combineTool.py -M T2W -i tt/* -o workspace.root --parallel 4
    #nohup combineTool.py -M Asymptotic -d */*/workspace.root --there -n .limit --parallel 4 &
    combineTool.py -M Asymptotic -d */*/workspace.root --there -t -1 -n .limit --parallel 4
    combineTool.py -M CollectLimits */*/higgsCombine.limit.Asymptotic.*.root --use-dirs -o limits.json
    cp limits_tt.json ../ptIso/${DATE}${BIN}Cmb.json
    for CAT in 0 1 2 3 4; do
        combineTool.py -M T2W -i tt/*/htt_tt_${CAT}_13TeV.txt -o workspace${CAT}.root --parallel 4
        #nohup combineTool.py -M Asymptotic -d */*/workspace.root --there -n .limit --parallel 4 &
        combineTool.py -M Asymptotic -d */*/workspace${CAT}.root --there -t -1 -n .limit${CAT} --parallel 4
        combineTool.py -M CollectLimits */*/higgsCombine.limit${CAT}.Asymptotic.*.root --use-dirs -o limits.json
        #cp limits_tt.json ../ptIso/${PT}${ISO}${VBF}${CAT}.json
        cp limits_tt.json ../ptIso/${DATE}${BIN}${CAT}.json
    done
    popd
done

echo "HERE WE ARE"

pushd output/ptIso
#for BIN in NoScaleGtrEq2 Oct14; do    
for BIN in Oct21Final; do    
    plotLimits.py ${DATE}${BIN}{0,1,2,3,4,Cmb}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    cp limit.pdf limit_All_${DATE}${BIN}.pdf
    #for CAT in 0 1 2 3 4; do
    #   plotLimits.py ${DATE}{NoScaleGtrEq2,Oct14}${CAT}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    #   cp limit.pdf limit_${DATE}Comp${CAT}.pdf
    #done
    rm limit.pdf
done
popd

#
#echo ""
#echo "Maximum Likelihood"
#echo ""
##NUM=1
#pushd output/htt_cards/tt/125/
##combine -M Asymptotic htt_tt_${NUM}_13TeV.txt -t -1
##combine -M ProfileLikelihood --significance htt_tt_${NUM}_13TeV.txt -t -1 --expectSignal=1
#popd
#
#
#echo ""
#echo "PULLS"
#echo ""
#pushd output/htt_cards
##combine -M MaxLikelihoodFit tt/125/workspace.root  --robustFit=1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.5 --rMax 1.5
##python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -A -a --stol 0.99 --stol 0.99 --vtol 99. --vtol2 99. -f text mlfit.root > ../mlfit/mlfit${BIN}Cmb.txt
##for CAT in 1 2 3 4; do
##    combine -M MaxLikelihoodFit tt/125/workspace${CAT}.root  --robustFit=1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.5 --rMax 1.5
##    python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -A -a --stol 0.99 --stol 0.99 --vtol 99. --vtol2 99. -f text mlfit.root > ../mlfit/mlfit${BIN}${CAT}.txt
##done
#popd






##### IMPACTS
#BIN=NoScaleGtrEq2
#pushd output/htt_cards
#combineTool.py -M Impacts -d tt/125/workspace.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1 --expectSignal=1 --rMin=-5.
#combineTool.py -M Impacts -d tt/125/workspace.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1 --expectSignal=1 --rMin=-5.
#combineTool.py -M Impacts -d tt/125/workspace.root -m 125 -o ../impacts/impacts${BIN}Cmb.json
#plotImpacts.py -i ../impacts/impacts${BIN}Cmb.json -o ../impacts/impacts${DATE}${BIN}Cmb
#for CAT in 0 1 2 3 4; do
#    #combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.01 --rMax 4.
#    #combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.01 --rMax 4.
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1 --expectSignal=1 --rMin=-5.
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1 --expectSignal=1 --rMin=-5.
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 -o ../impacts/impacts${BIN}${CAT}.json
#    plotImpacts.py -i ../impacts/impacts${BIN}${CAT}.json -o ../impacts/impacts${DATE}${BIN}${CAT}
#done
#popd




