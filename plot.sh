#MTHD=QCDNew
MTHD=2D
DIRBASE=output2d
mkdir -p ${DIRBASE}/plots

cd ${DIRBASE}/htt_cards/tt/125
text2workspace.py htt_tt_1_13TeV.txt
combine -M MaxLikelihoodFit workspace.root -m 125 --robustFit=1 --preFitValue=1. --X-rtd FITTER_NEW_CROSSING_ALGO --minimizerAlgoForMinos=Minuit2 --minimizerToleranceForMinos=0.1 --X-rtd FITTER_NEVER_GIVE_UP --X-rtd FITTER_BOUND --minimizerAlgo=Minuit2 --minimizerStrategy=0 --minimizerTolerance=0.1 --cminFallbackAlgo \"Minuit2,0:1.\"  --rMin 0.35 --rMax 1.3 > fit_output${MTHD}.txt
PostFitShapesFromWorkspace -o ztt_tt_shapes${MTHD}.root -f mlfit.root:fit_s --postfit --sampling --print -d htt_tt_1_13TeV.txt -w workspace.root
cd ../../../..

echo "Plots"
cd $DIRBASE/plots
python ../../Draw_postfit.py --mthd=${MTHD}
cd ../..
