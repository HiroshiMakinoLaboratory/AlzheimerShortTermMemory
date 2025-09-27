# FORCE RNN

## Training RNN models

1. Clone the repository.
```
git clone https://github.com/HiroshiMakinoLaboratory/AlzheimerShortTermMemory.git
```

2. Create a conda environment.
```
cd AlzheimerShortTermMemory/RNN/RNN_training
conda env create -f environment.yml
conda activate rnn
```

3. Training.
```
python training.py
```

4. Distract.
```
python distract.py
```

5. Individual region ablation
```
python distract_individual_region_ablation.py
```