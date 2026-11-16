# UCDNet: Self-Supervised Seismic Reconstruction via Deep Unfolding Convolutional Dictionary Learning

This repository provides the implementation of UCDNet for seismic data interpolation.

## Environment

The required Python packages are listed in `requirements.txt`. Install the dependencies using:

```bash
pip install -r requirements.txt
```

## Testing

Run:

```bash
python test.py
```

After testing, the reconstructed seismic results and related data will be saved in the `result_mat/` folder.

The script loads the test data, sampling masks, and trained networks:

1. Test data (test1.mat) with 50% irregularly missing traces.
2. Test data (test2.mat) with 50% regularly missing traces.
3. Test data (test3.mat) with 66.7% irregularly missing traces.
4. Noisy test data (test1.mat) with 50% irregularly missing traces.

## Trained network

The `trained_network/` directory contains four trained networks:

```text
test_1_trained.pt
test_2_trained.pt
test_3_trained.pt
test_4_trained.pt
```

## Saved Results

The `result_mat/` directory contains the sampling information and reconstruction results used by the MATLAB plotting scripts. The `.mat` files include the complete seismic data, observed data, reconstructed data, sampling masks.

## Figure Reproduction

The MATLAB scripts in the `plots` folder are provided to reproduce the figures in the manuscript.

### Training-loss curves

```text
training_loss.m
```

This script reads the three `.npy` files in `record_data/` and reproduces the training loss curves corresponding to Figure 3.

### Numerical examples

The scripts `test_1.m`, ..., `test_4.m` are used to reproduce different seismic interpolation experiments in the manuscript.

### MATLAB utilities

- `seg_colormap.m` provides the seismic visualization colormap.
- `cbrewer2/` provides ColorBrewer colormaps.
- `npy-matlab/` provides MATLAB support for reading `.npy` files.
