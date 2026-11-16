import numpy as np
import os
import scipy.io as io


def data_read(files_name):
    """
    Read seismic data from a MATLAB (.mat) file.
    """
    mat_data = io.loadmat(files_name)
    key = list(mat_data.keys())
    data = mat_data[key[-1]]
    return data

def data_augment(img: np.ndarray, mode: int = 0) -> np.ndarray:
    """
    Apply data augmentation using rotations and flips.
    """
    if mode == 0:
        return img
    elif mode == 1:
        return np.flipud(np.rot90(img))
    elif mode == 2:
        return np.flipud(img)
    elif mode == 3:
        return np.rot90(img, k=3)
    elif mode == 4:
        return np.flipud(np.rot90(img, k=2))
    elif mode == 5:
        return np.rot90(img)
    elif mode == 6:
        return np.rot90(img, k=2)
    elif mode == 7:
        return np.flipud(np.rot90(img, k=3))
    else:
        raise ValueError


def data_normalization(data: np.ndarray) -> np.ndarray:
    """
    Normalize seismic data to the range [0, 1].
    """
    data_float64 = data.astype(np.float64) 
    data_max = np.max(data_float64)
    data_min = np.min(data_float64)
    data_ = data_float64 - data_min   
    epsilon = 1e-8
    data_normalized = data_ / (data_max - data_min + epsilon)

    return data_normalized

def random_mask(rows, cols, missing_rate, seed=None):
    """
    Generate a random sampling mask for seismic interpolation.
    """
    rng = np.random.RandomState(seed) if seed is not None else np.random
    mask = np.ones((rows, cols), dtype=np.float32)
    missing_nums = int(np.floor(cols * missing_rate))
    missing_cols = rng.choice(cols, size=missing_nums, replace=False)
    mask[:, missing_cols] = 0
    mask[:, 0] = 1
    mask[:, -1] = 1
    return mask

def regular_mask(rows, cols, missing_rate):
    """
    Generate a regular sampling mask for seismic interpolation.
    """
    mask = np.zeros((rows, cols), dtype=np.float32)
    nums = cols
    for i in range(nums):
        if np.mod(i,missing_rate) == 0:
            mask[:, i] = 1
    mask[:, nums-1] = 1
    return mask


def SNR_calculation(data_clean, data_noisy):
    """
    Calculate signal-to-noise ratio (SNR).
    """
    data_clean = np.array(data_clean)
    data_noisy = np.array(data_noisy)

    if data_clean.shape != data_noisy.shape:
        print(f"SNR shape mismatch: clean {data_clean.shape}, noisy {data_noisy.shape}")
        return 0

    if np.any(np.isnan(data_clean)) or np.any(np.isnan(data_noisy)):
        print("NaN detected in input arrays!")
        return 0

    if np.any(np.isinf(data_clean)) or np.any(np.isinf(data_noisy)):
        print("Inf detected in input arrays!")
        return 0
    clean_power = np.mean(data_clean ** 2)
    noise_power = np.mean((data_clean - data_noisy) ** 2) + 1e-10
    if clean_power <= 0:
        print(f"Warning: clean_power={clean_power} <= 0")
        return 0
    if noise_power <= 0:
        print(f"Warning: noise_power={noise_power} <= 0")
        return 0
    return 10 * np.log10(clean_power / noise_power)


def add_noise_numpy(clean_data, noise_level, seed=None):
    """
    Add Gaussian noise to seismic data.
    """
    if seed is not None:
        rng = np.random.RandomState(seed)   
    else:
        rng = np.random

    noisy_data = clean_data + rng.randn(*clean_data.shape) * noise_level
    return noisy_data


def save_metrics(train_loss, val_loss, val_snr, prefix):
    """
    save loss and SNR values during training.
    """
    os.makedirs('./record_result/result_data', exist_ok=True)

    np.save(f'./record_result/{prefix}_train_loss.npy', np.array([train_loss]))
    np.save(f'./record_result/{prefix}_val_loss.npy', np.array([val_loss]))
    np.save(f'./record_result/{prefix}_testsnr.npy', np.array([val_snr]))

