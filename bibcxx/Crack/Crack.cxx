/**
 * @file Crack.cxx
 * @brief Implementation de CrackClass
 * @author Nicolas Pignet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

/* person_in_charge: nicolas.pignet at edf.fr */

#include "Crack/Crack.h"

CrackClass::CrackClass( const std::string name )
    : DataStructure( name, 8, "FOND_FISSURE", Permanent ),
      _levreInfMail( JeveuxVectorChar8( getName() + ".LEVREINF.MAIL" ) ),
      _normale( JeveuxVectorReal( getName() + ".NORMALE" ) ),
      _fondNoeu( JeveuxVectorChar8( getName() + ".FOND.NOEUD" ) ),
      _infNormNoeud( JeveuxVectorChar8( getName() + ".INFNORM.NOEU" ) ),
      _supNormNoeu( JeveuxVectorChar8( getName() + ".SUPNORM.NOEU" ) ),
      _levreSupMail( JeveuxVectorChar8( getName() + ".LEVRESUP.MAIL" ) ),
      _info( JeveuxVectorChar8( getName() + ".INFO" ) ),
      _fondTailleR( JeveuxVectorReal( getName() + ".FOND.TAILLE_R" ) ),
      _abscur( JeveuxVectorReal( getName() + ".ABSCUR" ) ),
      _ltno( new FieldOnNodesRealClass( getName() + ".LTNO      " ) ),
      _lnno( new FieldOnNodesRealClass( getName() + ".LNNO      " ) ),
      _basLoc( new FieldOnNodesRealClass( getName() + ".BASLOC    " ) ){};
