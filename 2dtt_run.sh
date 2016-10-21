PT=5040
ISO=Tight
BIN=Final
DATE=Oct21


rm -r output2d/htt_cards/
##for BIN in 2D 2DB 2DC; do
for BIN in Oct21Final; do
    cp data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV_svFitMass2D-5040-Tight-ICHEP-${BIN}.root data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV.root
    HTT-2Dtt
    pushd output2d/htt_cards
    combineTool.py -M T2W -i tt/* -o workspace.root --parallel 4
    combineTool.py -M Asymptotic -d */*/workspace.root --there -t -1 -n .limit --parallel 4
    combineTool.py -M CollectLimits */*/higgsCombine.limit.Asymptotic.*.root --use-dirs -o limits.json
    cp limits_tt.json ../ptIso/${DATE}${BIN}Cmb.json
    for CAT in 0 1 2; do
        combineTool.py -M T2W -i tt/*/htt_tt_${CAT}_13TeV.txt -o workspace${CAT}.root --parallel 4
        combineTool.py -M Asymptotic -d */*/workspace${CAT}.root --there -t -1 -n .limit${CAT} --parallel 4
        combineTool.py -M CollectLimits */*/higgsCombine.limit${CAT}.Asymptotic.*.root --use-dirs -o limits.json
        cp limits_tt.json ../ptIso/${DATE}${BIN}${CAT}.json
    done
    popd
done

echo "HERE WE ARE"

mkdir -p output2d/ptIso
pushd output2d/ptIso
#plotLimits.py Oct{122D,182DD}0.json:exp0 --auto-style
#cp limit.pdf limit_${DATE}_HiggsPtVsMjjUnroll_Comp${BIN}0.pdf
for BIN in Oct21Final; do    
    plotLimits.py ${DATE}${BIN}{0,1,2,Cmb}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    #plotLimits.py ${DATE}${BIN}{1,Cmb}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    cp limit.pdf limit_2D_All_${DATE}${BIN}.pdf
    #for CAT in 0 1; do
    #for CAT in 1; do
    #   plotLimits.py ${DATE}{2D,2DB,2DC,2DE}${CAT}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    #   cp limit.pdf limit_all4_${DATE}_HiggsPtVsMjjUnroll_Comp${BIN}${CAT}.pdf
    #done
    rm limit.pdf
done
popd

#
#echo ""
#echo "Maximum Likelihood"
#echo ""
##NUM=1
#pushd output2d/htt_cards/tt/125/
##combine -M Asymptotic htt_tt_${NUM}_13TeV.txt -t -1
##combine -M ProfileLikelihood --significance htt_tt_${NUM}_13TeV.txt -t -1 --expectSignal=1
#popd
#
#
#echo ""
#echo "PULLS"
#echo ""
#pushd output2d/htt_cards
##combine -M MaxLikelihoodFit tt/125/workspace.root  --robustFit=1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.5 --rMax 1.5
##python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -A -a --stol 0.99 --stol 0.99 --vtol 99. --vtol2 99. -f text mlfit.root > ../mlfit/mlfit${BIN}Cmb.txt
##for CAT in 1 2 3 4; do
##    combine -M MaxLikelihoodFit tt/125/workspace${CAT}.root  --robustFit=1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.5 --rMax 1.5
##    python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py mlfit.root -A -a --stol 0.99 --stol 0.99 --vtol 99. --vtol2 99. -f text mlfit.root > ../mlfit/mlfit${BIN}${CAT}.txt
##done
#popd






##### IMPACTS
#BIN=NoScaleGtrEq2
#pushd output2d/htt_cards
##combineTool.py -M Impacts -d tt/125/workspace.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.1 --rMax 2.
##combineTool.py -M Impacts -d tt/125/workspace.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.1 --rMax 2.
##combineTool.py -M Impacts -d tt/125/workspace.root -m 125 -o ../impacts/impacts${BIN}Cmb.json
##plotImpacts.py -i ../impacts/impacts${BIN}Cmb.json -o ../impacts/impacts${DATE}${BIN}Cmb
#for CAT in 0 1 2 3 4; do
#    #combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.01 --rMax 4.
#    #combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.01 --rMax 4.
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --doInitialFit --robustFit 1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 --robustFit 1 --doFits --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\" -t -1
#    combineTool.py -M Impacts -d tt/125/workspace${CAT}.root -m 125 -o ../impacts/impacts${BIN}${CAT}.json
#    plotImpacts.py -i ../impacts/impacts${BIN}${CAT}.json -o ../impacts/impacts${DATE}${BIN}${CAT}
#done
#popd




