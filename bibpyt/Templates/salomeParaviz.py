# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# aslint: disable=C4008

# TODO Probably obsolete
#
import os
#%====================Initialisation Salome================================%
import re
import sys

import salome
import salome_kernel
import SALOMEDS

# NOM_PARA requis dans EXEC_LOGICIEL: INPUTFILE1, CHOIX

# Pour isovaleurs
# INPUTFILE1 : Fichier de resultat MED
# CHOIX = 'DEPL', 'ISO', 'GAUSS', 'ON_DEFORMED'

# Pour courbes
# INPUTFILE1 : Fichier de resultat TXT
# CHOIX = 'COURBE'



if 'CHOIX' not in ['DEPL', 'ISO', 'GAUSS', 'COURBE', 'ON_DEFORMED']:
    raise Exception("Erreur de type de visualisation!")
if not os.path.isfile('INPUTFILE1'):
    raise Exception("Fichier %s non present!" % 'INPUTFILE1')


orb, lcc, naming_service, cm = salome_kernel.salome_kernel_init()
obj = naming_service.Resolve('myStudyManager')
myStudyManager = obj._narrow(SALOMEDS.StudyManager)

root = os.path.normpath(
    os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))))
file1 = os.path.join(root, 'INPUTFILE1')
if not os.path.isfile(file1):
    raise Exception("Fichier %s non present!" % 'INPUTFILE1')

#%====================Initialisation etude================================%

salome.salome_init()

#%=================== Initialisation paravis ============================%
try:
    pvsimple
except:
    import pvsimple as PV

#%===================Construction courbe======================%

# selection de la vue adequate
view = None
try:
    # Cas vue active OK
    v = GetActiveView()
    if 'CHOIX' == 'COURBE':
        if 'LineChartView' in str(type(v)):
            view = v
    else:
        if 'RenderView' in str(type(v)):
            view = v
except:
    try:
        # Cas plusieurs vues
        anim = GetAnimationScene()
        liste_view = anim.ViewModules
        for v in liste_view:
            if 'CHOIX' == 'COURBE':
                if 'LineChartView' in str(type(v)):
                    view = v
            else:
                if 'RenderView' in str(type(v)):
                    view = v

    except:
        pass
if view is None and 'CHOIX' == 'COURBE':
    view = PV.CreateXYPlotView()
if view is None and 'CHOIX' != 'COURBE':
    view = PV.CreateRenderView()
PV.SetActiveView(view)
L = view.Representations
for i in L:
    i.Visibility = 0


nocomment = re.compile('^[^#].*', re.M)
title = re.compile('^#COLUMN_TITLES: *(.*)$', re.M)

def convert(fname):
    """Convert in place an output file from Stanley for Paravis"""
    with open(fname, 'r') as f:
        txt = f.read()
    mat = title.search(txt)
    assert mat, "COLUMN_TITLES not found"
    label = mat.group(1).split('|')
    values = nocomment.findall(txt)
    cont = [' '.join(label)]
    cont.extend(values)
    with open(fname, 'w') as f:
        f.write(os.linesep.join(cont))


if 'CHOIX' == 'COURBE':
    CHOIXF = 'COURBE'

    # reader Table
    convert(file1)
    myResult = PV.CSVReader(FileName=file1)
    if myResult is None:
        raise "Erreur de fichier"
    myResult.FieldDelimiterCharacters = ' '
    myResult.MergeConsecutiveDelimiters = 1
    PV.Render()

    courbe = PV.PlotData()

    display = PV.Show()
    display.AttributeType = 'Row Data'
    display.UseIndexForXAxis = 0

    labels = display.GetProperty('SeriesLabel')

    display.XArrayName = labels[0]

    display.SeriesVisibility = labels[2:]

    PV.Render()

#%====================Construction isovaleurs====================%

if 'CHOIX' != 'COURBE':

    myResult = PV.MEDReader(FileName=file1)
    if myResult is None:
        raise Exception("Erreur de fichier MED")

    keys = myResult.GetProperty('FieldsTreeInfo')[::2]
    arrs_with_dis = [elt.split()[-1] for elt in keys]
    arrs = [elt.split(myResult.GetProperty('Separator').GetData())
            for elt in arrs_with_dis]
    id_champ = [[nom.split('/')[3], type] for nom, type in arrs]

    CHOIXF = 'CHOIX'

    # Champ variable ou non

    NB_ORDRE = len(myResult.GetProperty('TimestepValues'))

if CHOIXF == 'ISO':

    # Recuperation du champ et application filtre ELNO si necessaire

    resu = myResult

    NOM_CHAMP = id_champ[0][0]
    TYPE_CHAMP = id_champ[0][1]
    if TYPE_CHAMP == "P0":
        pd = resu.CellData
    if TYPE_CHAMP == "P1":
        pd = resu.PointData
    if TYPE_CHAMP == "GSSNE":
        resu = PV.ELNOfieldToSurface()
        pd = resu.PointData

    # Recuperation des informations du champ
    for i in range(len(pd)):
        if list(pd.values())[i - 1].GetName() == NOM_CHAMP:
            NB_CMP = list(pd.values())[i - 1].GetNumberOfComponents()
            NOM_CMP = list(pd.values())[i - 1].GetComponentName(0)
            RANGE_CMP = list(pd.values())[i - 1].GetRange()

    # Attributs de visualisation
    CMP = 'Component'
    TYPE = 'Surface With Edges'


if CHOIXF == 'GAUSS':

    # Application filtre ELGA

    for nom, type in id_champ:
        if type == "GAUSS":
            NOM_CHAMP = nom
            break

    resu = PV.ELGAfieldToPointSprite()

    nom = "ELGA@" + "0"
    resu.SelectSourceArray = ['CELLS', nom]

    pd = resu.PointData

    # Recuperation des informations du champ
    for i in range(len(pd)):
        if list(pd.values())[i - 1].GetName() == NOM_CHAMP:
            NB_CMP = list(pd.values())[i - 1].GetNumberOfComponents()
            NOM_CMP = list(pd.values())[i - 1].GetComponentName(0)
            RANGE_CMP = list(pd.values())[i - 1].GetRange()

    # Attributs de visualisation
    CMP = 'Component'
    TYPE = 'Points'


if CHOIXF == 'DEPL':

    resu = myResult

    NOM_CHAMP = id_champ[0][0]
    NOM_CHAMP_DEF = NOM_CHAMP

    # Recuperation des informations du champ DEPL
    pd = resu.PointData

    for i in range(len(pd)):
        if list(pd.values())[i - 1].GetName() == NOM_CHAMP:
            RANGE_CMP = list(pd.values())[i - 1].GetRange()
            NB_CMP = list(pd.values())[i - 1].GetNumberOfComponents()

    # Filtre calculator si NB_CMP different de 3

    if NB_CMP == 2:
        resu = PV.Calculator()
        resu.Function = NOM_CHAMP_DEF + \
            "_DX*iHat+" + NOM_CHAMP_DEF + "_DY*jHat+0*kHat"
        resu.ResultArrayName = NOM_CHAMP_DEF + "_Vector"
        NOM_CHAMP_DEF = NOM_CHAMP_DEF + "_Vector"
    if NB_CMP > 3:
        resu = PV.Calculator()
        resu.Function = NOM_CHAMP_DEF + "_DX*iHat+" + \
            NOM_CHAMP_DEF + "_DY*jHat+" + NOM_CHAMP_DEF + "_DZ*kHat"
        resu.ResultArrayName = NOM_CHAMP_DEF + "_Vector"
        NOM_CHAMP_DEF = NOM_CHAMP_DEF + "_Vector"

    # Filtre Warp by Vector
    resu = PV.WarpByVector()
    resu.Vectors = ['POINTS', NOM_CHAMP_DEF]
    pd = resu.PointData

    MAX_CMP = max(abs(RANGE_CMP[0]), abs(RANGE_CMP[1]))
    if MAX_CMP == 0.:
        MAX_CMP = 1.
    SCALE_FACTOR = 1. / MAX_CMP

    # Attributs de visualisation
    CMP = 'Magnitude'
    TYPE = 'Surface With Edges'
    NOM_CMP = ''
    NB_CMP = 3


if CHOIXF == 'ON_DEFORMED':

    resu = myResult

    # Recuperation des informations du champ
    # Initialisation DEPL premier champ
    NOM_CHAMP = id_champ[1][0]
    TYPE_CHAMP = id_champ[1][1]
    NOM_CHAMP_DEF = id_champ[0][0]
    if TYPE_CHAMP != "P1":
        NOM_CHAMP = id_champ[0][0]
        TYPE_CHAMP = id_champ[0][1]
        NOM_CHAMP_DEF = id_champ[1][0]
    else:
        if ("DEPL" not in NOM_CHAMP_DEF) and (id_champ[1][1] == "P1"):
            NOM_CHAMP = id_champ[0][0]
            TYPE_CHAMP = id_champ[0][1]
            NOM_CHAMP_DEF = id_champ[1][0]

    # Traitement selon TYPE_CHAMP
    if TYPE_CHAMP == "P0":
        pd = resu.CellData
    if TYPE_CHAMP == "P1":
        pd = resu.PointData
    if TYPE_CHAMP == "GSSNE":
        resu = PV.ELNOfieldToSurface()
        pd = resu.PointData

    for i in range(len(pd)):
        if list(pd.values())[i - 1].GetName() == NOM_CHAMP:
            NOM_CMP = list(pd.values())[i - 1].GetComponentName(0)
            NB_CMP = list(pd.values())[i - 1].GetNumberOfComponents()
            RANGE_CMP = list(pd.values())[i - 1].GetRange()

    # Recuperation des informations du champ DEPL
    pd1 = resu.PointData
    for i in range(len(pd1)):
        if list(pd1.values())[i - 1].GetName() == NOM_CHAMP_DEF:
            NB_CMP_DEF = list(pd1.values())[i - 1].GetNumberOfComponents()
            RANGE_CMP_DEF = list(pd1.values())[i - 1].GetRange()

    if NB_CMP_DEF == 2:
        resu = PV.Calculator()
        resu.Function = NOM_CHAMP_DEF + \
            "_DX*iHat+" + NOM_CHAMP_DEF + "_DY*jHat+0*kHat"
        resu.ResultArrayName = NOM_CHAMP_DEF + "_Vector"
        NOM_CHAMP_DEF = NOM_CHAMP_DEF + "_Vector"
    if NB_CMP_DEF > 3:
        resu = PV.Calculator()
        resu.Function = NOM_CHAMP_DEF + "_DX*iHat+" + \
            NOM_CHAMP_DEF + "_DY*jHat+" + NOM_CHAMP_DEF + "_DZ*kHat"
        resu.ResultArrayName = NOM_CHAMP_DEF + "_Vector"
        NOM_CHAMP_DEF = NOM_CHAMP_DEF + "_Vector"

    resu = PV.WarpByVector()
    resu.Vectors = ['POINTS', NOM_CHAMP_DEF]

    MAX_CMP = max(abs(RANGE_CMP_DEF[0]), abs(RANGE_CMP_DEF[1]))
    if MAX_CMP == 0.:
        MAX_CMP = 1.
    SCALE_FACTOR = 1. / MAX_CMP

    # Attributs de visualisation
    CMP = 'Component'
    TYPE = 'Surface With Edges'


#%=============== Affichage ============================%

if CHOIXF != 'COURBE':

    # Visualisation
    if NB_ORDRE > 1:
        anim = PV.GetAnimationScene()
        anim.Loop = 1
        # anim.PlayMode = 'Sequence'
        # anim.NumberOfFrames = 50

    if CHOIXF == 'DEPL' or CHOIXF == 'ON_DEFORMED':
        resu.ScaleFactor = SCALE_FACTOR

    display = PV.Show()
    display.ColorArrayName = NOM_CHAMP
    display.Representation = TYPE
    if RANGE_CMP[0] == RANGE_CMP[1]:
        max_scalar = 1.01 * RANGE_CMP[1]
    else:
        max_scalar = RANGE_CMP[1]
    CH_PVLookupTable = PV.GetLookupTableForArray(NOM_CHAMP, NB_CMP,
                                              VectorMode=CMP,
                                              RGBPoints=[
                                                  RANGE_CMP[
                                                      0], 0.0, 0.0, 1.0, max_scalar, 1.0, 0.0, 0.0],
                                              ScalarRangeInitialized=1.0)
    display.LookupTable = CH_PVLookupTable

    if CHOIXF == 'GAUSS':
        display.RadiusArray = [None, NOM_CHAMP]
        display.RadiusMode = 'Scalar'
        display.RadiusScalarRange = RANGE_CMP

    scalarbar = PV.CreateScalarBar(Title=NOM_CHAMP, ComponentTitle=NOM_CMP,
                                LookupTable=CH_PVLookupTable, TitleFontSize=12, LabelFontSize=12)
    view.Representations.append(scalarbar)

    PV.Render()
    PV.ResetCamera()
