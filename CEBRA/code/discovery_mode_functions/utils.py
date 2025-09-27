import torch
import random
import h5py
import numpy as np


def set_seed(seed, device_id='cuda:0'):
    # Set seed for Python's built-in random library
    random.seed(seed)
    # Set seed for numpy
    np.random.seed(seed)
    # Set seed for PyTorch CPU
    torch.manual_seed(seed)

    if torch.cuda.is_available():
        # Set device-specific seed for the specified GPU
        torch.cuda.set_device(device_id)
        torch.cuda.manual_seed(seed)

        # Ensure deterministic behavior on the specified GPU (may impact performance)
        torch.backends.cudnn.deterministic = True
        torch.backends.cudnn.benchmark = False


def save_dict_to_h5(dic, filename):
    def recursively_save(h5file, path, obj):
        for key, value in obj.items():
            key = str(key)  # ensure valid HDF5 key
            full_path = f"{path}/{key}"
            if isinstance(value, dict):
                group = h5file.require_group(full_path)
                recursively_save(h5file, full_path, value)
            else:
                try:
                    h5file.create_dataset(full_path, data=value)
                except TypeError:
                    # Fallback for non-numeric data (e.g., list of strings)
                    h5file.create_dataset(full_path, data=np.string_(str(value)))

    with h5py.File(filename, 'w') as h5file:
        recursively_save(h5file, '', dic)