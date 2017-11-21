/**
 * @file CrackTip.cxx
 * @brief Implementation de CrackTipInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modeling/CrackTip.h"

CrackTipInstance::CrackTipInstance():
    DataStructure( "FOND_FISS", Permanent, 8 ),
    _info( JeveuxVectorChar8( getName() + ".INFO" ) ),
    _fondFiss( JeveuxVectorDouble( getName() + ".FONDFISS" ) ),
    _fondType( JeveuxVectorChar8( getName() + ".FOND.TYPE" ) ),
    _fondNoeu( JeveuxVectorChar8( getName() + ".FOND.NOEUD" ) ),
    _fondInfNoeu( JeveuxVectorChar8( getName() + ".FONDINF.NOEU" ) ),
    _fondSupNoeu( JeveuxVectorChar8( getName() + ".FONDSUP.NOEU" ) ),
    _fondFisG( JeveuxVectorDouble( getName() + ".FONDFISG" ) ),
    _normale( JeveuxVectorDouble( getName() + ".NORMALE" ) ),
    _baseFond( JeveuxVectorDouble( getName() + ".BASEFOND" ) ),
    _ltno( new FieldOnNodesDoubleInstance( getName() + ".LTNO      " ) ),
    _lnno( new FieldOnNodesDoubleInstance( getName() + ".LNNO      " ) ),
    _basLoc( new FieldOnNodesDoubleInstance( getName() + ".BASLOC    " ) ),
    _fondTailleR( JeveuxVectorDouble( getName() + ".FOND.TAILLE_R" ) ),
    _dtanOrigine( JeveuxVectorDouble( getName() + ".DTAN_ORIGINE" ) ),
    _dtanExtremite( JeveuxVectorDouble( getName() + ".DTAN_EXTREMITE" ) ),
    _levreSupMail( JeveuxVectorChar8( getName() + ".LEVRESUP.MAIL" ) ),
    _supNormNoeu( JeveuxVectorChar8( getName() + ".SUPNORM.NOEU" ) ),
    _levreInfMail( JeveuxVectorChar8( getName() + ".LEVREINF.MAIL" ) ),
    _infNormNoeud( JeveuxVectorChar8( getName() + ".INFNORM.NOEU" ) )
{};