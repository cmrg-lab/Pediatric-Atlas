# Pediatric Atlas Scripts

Descriptions of the scripts included.

## Atlas Creation
- `extractPoints.m`: extracts 3D ED/ES points from model files (generated from a modeling pipeline like <a href="https://github.com/btcrabb/CAP-Automated-Pipeline">CAP-Automated-Pipeline</a> or <a href="https://github.com/UOA-Heart-Mechanics-Research/biv-me">biv-me</a>) and aligns them to a normal template.
- `alignPoints.m`: aligns 3D points to each other using Procrustes alignment. The models can also optionally be corrected for height.
- `genAtlas.m`: generates a statistical shape atlas using principal component analysis. 

## Post-analysis

- `analyzeCorrelations.m`: creates correlation matrices between the principal component scores of an atlas and certain clinical and functional metrics. Individual-level data such as blood pressures, ages, heights, etc. is needed to run this this script and will not be publicly available.
- `atlasViewer.m`: visualizes and saves the shape variations due to each mode of the atlas as well as the mean atlas shape. 
- `compareCohorts.m`: separates participants used to geenrate the atlas into multiple cohorts (men vs. women, bmi >= 30 vs. bmi < 30, etc.) and quantitatively compares their PC scores.
- `distanceAnalysis.m`: performs a Mahalanobis distance analysis on projections of a cohort onto two separate atlases. 
- `genZScores.m`: extracts patient-specific PC scores from the atlas. 
- `makeModeMovies.m`: create gifs of how each PC changes across its score distribution.
- `plotVarianceExplained.m`: graphs the individual and cumulative variance explained by each shape mode in the atlas.
- `projectOntoAtlas.m` will generate shape mode scores for an external or internal patient-specific model file containing 3D points by projecting it onto an atlas. 

### Helper Files
- `helpers/genEDESModels.m`: generates a 3D shape point cloud using individual PC-scores an an atlas. 
- `helpers/plotSurface.m`: plots mesh surfaces.
- `helpers/plotValves.m`: plots valves.
- `helpers/plotWireframe.m`: plots the surfaces in a wireframe format.
- `helpers/Subdivion_Surface.m`: class that defines the template mesh that the models are fitted onto.