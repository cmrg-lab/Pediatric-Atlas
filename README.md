# Pediatric Cardiac Shape Atlas

<a href="https://doi.org/10.5281/zenodo.17554213"><img src="https://zenodo.org/badge/986615907.svg" alt="DOI"></a>

<p align="center">
 <img src="./Images/pedatlas_characterization/pedatlas_average_shape.png" width="300">
</p>

A set of MATLAB tools for interacting with a normative **biventricular pediatric cardiac shape atlas** built from 101 healthy patients aged 2.3-19.3 years. This atlas is constructed at both **end-diastole (ED)** and **end-systole (ES)** using principal component analysis (PCA) and can be used to:

- Explore and visualize the modes of shape variation in a healthy pediatric population
- Project patient models onto the atlas to obtain shape mode Z-scores that quantify how a patient's cardiac morphology deviates from healthy pediatric norms
- Analyze regionally how patients with disease differ from healthy pediatric patients

Standard clinical metrics (volumes, ejection fractions, wall thickness) provide a limited view of cardiac geometry. This atlas captures global and regional variation in ventricular size, shape, and function in a single, quantative framework - offering a richer characterization of pediatric cardiac morphology than scalar indices alone. 

## Table of Contents
 
- [Atlas Description](#atlas-description)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Project Directory Structure](#project-directory-structure)
- [Data Access](#data-access)
- [Contact & Citation](#contact--citation)

## Atlas Description

The atlas was derived from **101 healthy pediatric patients** imaged at Rady Children's Hospital San Diego. CMR images were acquired at 1.5T using standard ECG-gated, breath-held SSFP cine sequences. Biventricular models were generated using an automated deep learning pipeline and refined by expert review.

The atlas was built using PCA on Procrustes-aligned biventricular surface meshes. **8 shape modes** together explain **79.6%** of total shape variance in the cohort.

**Cohort summary:**
 
| Characteristic | Value (n=101) |
|---|---|
| Age (years) | 15.1 ± 2.7 |
| Sex (male / female) | 63% / 37%  |
| Height (cm) | 165.1 ± 14.7 |
| Weight (kg) | 62.1 ± 19.2 |

The shape variations captured by each of the first 8 modes of the atlas are visualized below (± 3 standard deviations from the mean shape):

<table>
  <tr>
    <th>Modes</th>
    <th>Anterior View</th>
    <th>Basal View</th>
    <th>Posterior View</th>
  </tr>
  <tr>
    <td> 1 </td>
    <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_1.gif"  width = 240px height = 240px ></td>
    <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_1.gif" width = 240px height = 240px></td>
    <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_1.gif" width = 240px height = 240px></td>
   </tr> 
   <tr>
     <td> 2 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_2.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_2.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_2.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 3 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_3.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_3.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_3.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 4 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_4.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_4.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_4.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 5 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_5.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_5.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_5.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 6 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_6.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_6.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_6.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 7 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_7.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_7.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_7.gif" width = 240px height = 240px></td>
  </tr>
  <tr>
     <td> 8 </td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Ant_8.gif"  width = 240px height = 240px ></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Base_8.gif" width = 240px height = 240px></td>
     <td><img src="Images/pedatlas_characterization/mode_movies/mode_EDES_Post_8.gif" width = 240px height = 240px></td>
  </tr>
</table>

The atlas has also been validated against a cohort of 65 pediatric Tetralogy of Fallot (ToF) patients. ToF patients showed significant deviations from the healthy pediatric mean in 6 out of the 8 retained modes. The largest deviations were in Modes 7, 6, 5, and 2: modes associated with pulmonary valve placements, right ventricular dilation, and right ventricular sphericity. 

<p align="right">(<a href="#pediatric-cardiac-shape-atlas">back to top</a>)</p>

## Getting Started

**Prerequisites**

- MATLAB R2021a or later (tested on R2025a)
- The Statistics and Machine Learning Toolbox is needed for some analyses

### Installation

Clone the repository:
 ```bash
git clone https://github.com/cmrg-lab/Pediatric-Atlas.git
cd Pediatric-Atlas
 ```

### Download relevant files

The atlas `.mat` files are not included in the repository due to file size. Stlas files and additional MATLAB files needed for some of the scripts are archived at the <a href="https://doi.org/10.5281/zenodo.17554213">Zenodo repository</a> linked to this project. 

Place the downloaded `.mat` files into the `Data/` directory before running scripts.

<p align="right">(<a href="#pediatric-cardiac-shape-atlas">back to top</a>)</p>

## Usage

Full documentation for the included scripts can be found in <a href="(./Scripts/README.md">`Scripts/README.md`</a>. The core workflows are:

**1. Atlas Creation**

To create a new atlas, 3D biventricular model files must first be added in the `Models/` folder. Model files can be created from raw CMRs using a pipeline such as <a href="https://github.com/UOA-Heart-Mechanics-Research/biv-me">biv-me</a>, for example. These scripts extract the 3D model coordinate points, use Procrustes alignment to correct for translation and rotation, and use PCA to create a statistical shape.

```matlab
% From the Scripts/directory:
run('extractPoints.m')
run('alignPoints.m')
run('genAtlas.m')
```

**2. Explore and visualize the atlas**

Loads the atlas and visualizes the mean shape and shape mode variations at ED and ES. Plots the variance explained by the shape modes. Derives z-scores for models used to generate the atlas. Analyzes correlations between atlas shape modes and clinical metrics. Cohorts within the atlas separated by sex, bmi, and/or age can also be compared mode-wise.

```matlab
run('atlasViewer.m')
run('plotVarianceExplained.m')
run('genZScores.m')
run('analyzeCorrelations.m')
run('compareCohorts.m')
```

**3. Project a new model onto the atlas**

Provide your own biventricular model as an input (an example one is included in `Models/`). This function will return per-mode Z-scores representing standard deviations from the healthy pediatric mean.

```matlab
run('projectOntoAtlas.m')
```

**4. Separate Cohort Analysis**

Visualizes and analyzes the regional deviations of a separate cohort projected onto the pediatric atlas. Computes the max and mean reconstruction errors when reconstructing an external cohort using the pediatric atlas PC scores.

```matlab
run('regionalAnalaysis.m')
run('reconstructionError.m')
```

<p align="right">(<a href="#pediatric-cardiac-shape-atlas">back to top</a>)</p>

## Project Directory Structure

```bash
├── Data/
│   └── MeshFiles/
├── Images/
│   ├── disease_comparison/
│   └── pedatlas_characterization/
├── Models/
├── Scripts/
│   ├── helpers/
│   └── README.md
├── .gitignore
├── LICENSE
└── README.md
```

<p align="right">(<a href="#pediatric-cardiac-shape-atlas">back to top</a>)</p>

## Data Access

**Individual patient data** (CMR images, clinical data, point clouds) can be made available through the <a href="https://capchd.ucsd.edu/#/">Cardiac Atlas Project</a> subject to a Data Use Agreement. The CAP IDs for both the pediatric healthy and diseased participants used in this work are listed on the <a href="https://capchd.ucsd.edu/#/pediatric">Pediatric Atlas page</a> for registered users. 

## Contact & Citation

Anna Qi - anqi@ucsd.edu

If you use the pediatric atlas or any these tools in your research, please cite:

> Qi, A. et al. (2025). A Pediatric Cardiac Shape Atlas: Insights into the Structure of Young Healthy Hearts. In: Chabiniok, R., Zou, Q., Hussain, T., Nguyen, H.H., Zaha, V.G., Gusseva, M. (eds) Functional Imaging and Modeling of the Heart. FIMH 2025. Lecture Notes in Computer Science, vol 15673. Springer, Cham. https://doi.org/10.1007/978-3-031-94562-5_14

A follow-up manuscript describing an expanded cohort (n=101) and Tetralogy of Fallot validation is under review. Please check back for an updated citation.

## License
 
Distributed under the Apache 2.0 License. See [`LICENSE`](LICENSE) for details.

<p align="right">(<a href="#pediatric-cardiac-shape-atlas">back to top</a>)</p>
