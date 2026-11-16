"""
This script loads trained models and evaluates interpolation performance on different seismic data.

Input:
    - Seismic data in ./datasets/
    - Sampling mask in ./result_mat/
    - Trained models in ./trained_network/

Output:
    - Reconstruction results saved in ./result_mat/
      including original data, observed data, reconstructed data, sampling mask, and SNR.
"""
import torch
import numpy as np
import scipy.io as io
from utils.utils_tools import SNR_calculation, data_normalization, regular_mask, random_mask, add_noise_numpy
# from model.module import ConvLista_T,ListaParams
import random

seed = 1124
random.seed(seed)
np.random.seed(seed)
torch.manual_seed(seed)
if torch.cuda.is_available():
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False


def test_result(data_path, sampling_path, network_path, save_path, add_noise,need_padding):
    """
    Test DCDLNet on one seismic data.

    Args:
        data_path: input seismic data path.
        sampling_path: sampling mask path.
        network_path: trained model path.
        save_path: output result path.
        missing_rate: missing trace rate.
        add_noise: whether to add noise.
        need_padding: whether to pad the input data.
    """
    mat = io.loadmat(data_path)
    name = list(mat.keys())
    d = mat[name[-1]]
    data = data_normalization(d)
    H, W = data.shape
    sampling_mat = io.loadmat(sampling_path)
    sampling = sampling_mat['sampling']
    mask = np.copy(sampling)
    d_obs = data * mask

    if need_padding:
        d_obs = np.pad(d_obs, ((0, 10), (0, 10)), constant_values=0)
        mask = np.pad(mask, ((0, 10), (0, 10)), constant_values=0)
    if add_noise:
        noisy_data = mask * (add_noise_numpy(data, 10 / 255, seed=1124))
    else:
        noisy_data = np.copy(d_obs)

    model = torch.jit.load(network_path, map_location='cpu')
    model.to(device)
    model.eval()
    with torch.no_grad():
        noisy_torch = torch.FloatTensor(noisy_data[None, None, :, :].copy()).to(device)
        mask_torch = torch.FloatTensor(mask[None, None, :, :].copy()).to(device)
        result_data = model(noisy_torch, mask_torch)
        if add_noise:
            recon_data = result_data
        else:
            recon_data = noisy_torch + (1 - mask_torch) * result_data
        recon = np.array(recon_data.detach().float().cpu().squeeze())
        recon_norm = recon[:H, :W]
        snr = SNR_calculation(data, recon_norm)
        print(f'snr:{snr}')
        data_dict = {
            'd': data,
            'd_obs': d_obs,
            'd_k': recon_norm,
            'snr': snr,
            'sampling': sampling}
        # io.savemat(save_path, data_dict)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(torch.cuda.is_available())
# Test 1: Noisy subsampled seismic data with 50% regularly missing traces
test_result(
    './datasets/test1.mat', './result_mat/test1_result.mat',
    './trained_network/test_1_trained.pt',
    './result_mat/test1_result.mat',
    False,False)

# Test 2: Subsampled data with 66.7% regularly missing traces
test_result(
    './datasets/test2.mat','./result_mat/test2_result.mat',
    './trained_network/test_2_trained.pt',
    './result_mat/test2_result.mat',
    False,True)

# Test 3: Subsampled data with 75% regularly missing traces
test_result(
    './datasets/test3.mat', './result_mat/test3_result.mat',
    './trained_network/test_3_trained.pt',
    './result_mat/test3_result.mat',
    False,False)

# Test 4: Noisy subsampled seismic data with 50% irregularly missing traces
test_result(
    './datasets/test1.mat','./result_mat/test4_result.mat',
    './trained_network/test_4_trained.pt',
    './result_mat/test4_result.mat',
    True,False)

