PT=4040
ISO=Tight
for VBF in NewVBFCat OldVBFCat; do
    cp data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV_svFitMass-${PT}-${ISO}_${VBF}.root data/sm_higgs_tautau/datacards/htt_tt.inputs-sm-13TeV.root
    HTT-tt
    pushd output/htt_cards
    combineTool.py -M T2W -i tt/* -o workspace.root --parallel 4
    #nohup combineTool.py -M Asymptotic -d */*/workspace.root --there -n .limit --parallel 4 &
    combineTool.py -M Asymptotic -d */*/workspace.root --there -t -1 -n .limit --parallel 4
    combineTool.py -M CollectLimits */*/higgsCombine.limit.Asymptotic.*.root --use-dirs -o limits.json
    cp limits_tt.json ../ptIso/${PT}${ISO}${VBF}Cmb.json
    for CAT in 1 2 3 4; do
        combineTool.py -M T2W -i tt/*/htt_tt_${CAT}_13TeV.txt -o workspace${CAT}.root --parallel 4
        #nohup combineTool.py -M Asymptotic -d */*/workspace.root --there -n .limit --parallel 4 &
        combineTool.py -M Asymptotic -d */*/workspace${CAT}.root --there -t -1 -n .limit${CAT} --parallel 4
        combineTool.py -M CollectLimits */*/higgsCombine.limit${CAT}.Asymptotic.*.root --use-dirs -o limits.json
        cp limits_tt.json ../ptIso/${PT}${ISO}${VBF}${CAT}.json
    done
    popd
done

echo "HERE WE ARE"

pushd output/ptIso
plotLimits.py ${PT}Tight{OldVBFCat,NewVBFCat}Cmb.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
cp limit.pdf limit_cmb.pdf
for CAT in 1 2 3 4; do
    plotLimits.py ${PT}Tight{OldVBFCat,NewVBFCat}${CAT}.json:exp0 --auto-style # will plot the expected limit comparisons of the channels
    cp limit.pdf limit_${CAT}.pdf
done
rm limit.pdf
popd


### From Cecile:
#combine -M Asymptotic smh_tt_${NUM}_13TeV_.txt -t -1
#combine -M ProfileLikelihood --significance smh_tt_${NUM}_13TeV_.txt -t -1 --expectSignal=1




