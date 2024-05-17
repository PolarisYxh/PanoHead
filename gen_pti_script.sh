#!/usr/bin/env bash

models=("easy-khair-180-gpc0.8-trans10-025000.pkl"\
  "ablation-trigridD-1-025000.pkl")

in="models"
out="pti_out2"

for model in ${models[@]}

do

    for i in 2 #foreach pictures

    do 
        echo $i
        # perform the pti and save w
        echo "python projector_withseg.py --outdir=${out} --target_img=dataset/mydata_img --network ${in}/${model} --idx ${i}"
        python projector_withseg.py --outdir=${out} --target_img=dataset/mydata_img --network ${in}/${model} --idx ${i}
        echo "----------------projector_withseg finish!"
        
        # generate .mp4 before finetune
        echo "python gen_videos_proj_withseg.py --output=${out}/${model}/${i}/PTI_render/pre.mp4 --latent=${out}/${model}/${i}/projected_w.npz --trunc 0.7 --network ${in}/${model} --cfg Head"
        python gen_videos_proj_withseg.py --output=${out}/${model}/${i}/PTI_render/pre.mp4 --latent=${out}/${model}/${i}/projected_w.npz --trunc 0.7 --network ${in}/${model} --cfg Head
        echo "----------------gen_videos_proj_withseg 0 finish!"

        # generate .mp4 after finetune
        echo "python gen_videos_proj_withseg.py --output=${out}/${model}/${i}/PTI_render/post.mp4 --latent=${out}/${model}/${i}/projected_w.npz --trunc 0.7 --network ${out}/${model}/${i}/fintuned_generator.pkl --cfg Head"
        python gen_videos_proj_withseg.py --output=${out}/${model}/${i}/PTI_render/post.mp4 --latent=${out}/${model}/${i}/projected_w.npz --trunc 0.7 --network ${out}/${model}/${i}/fintuned_generator.pkl --cfg Head
        echo "----------------gen_videos_proj_withseg 1 finish!"

    done

done
