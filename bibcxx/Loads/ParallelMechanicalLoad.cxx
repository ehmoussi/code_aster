/**
 * @file ParallelMechanicalLoad.cxx
 * @brief Implementation de ParallelMechanicalLoad
 * @author Nicolas Sellenet
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

#include "Loads/ParallelMechanicalLoad.h"
#include "Meshes/MeshExplorer.h"
#include "ParallelUtilities/MPIInfos.h"
#include "Supervis/ResultNaming.h"

#ifdef _USE_MPI

ParallelMechanicalLoadClass::ParallelMechanicalLoadClass(
        const std::string& name,
        const GenericMechanicalLoadPtr& load,
        const ModelPtr& model ):
    DataStructure( name, 8, "CHAR_MECA" ),
    _FEDesc( new ParallelFiniteElementDescriptorClass
                    ( getName() + ".CHME.LIGRE", load->getMechanicalLoadDescription()._FEDesc,
                      load->getModel()->getPartialMesh(), model ) ),
    _cimpo( new ConstantFieldOnCellsRealClass( getName() + ".CHME.CIMPO", _FEDesc ) ),
    _cmult( new ConstantFieldOnCellsRealClass( getName() + ".CHME.CMULT", _FEDesc ) ),
    _type( getName() + ".TYPE" ),
    _modelName( getName() + ".CHME.MODEL.NOMO" )
{
    _type->allocate( Permanent, 1 );
    (*_type)[0] = "MECA_RE ";
    _modelName->allocate( Permanent, 1 );
    (*_modelName)[0] = model->getName();

    transferConstantFieldOnCells( load->getMechanicalLoadDescription()._cimpo, _cimpo );
    transferConstantFieldOnCells( load->getMechanicalLoadDescription()._cmult, _cmult );
};

void
ParallelMechanicalLoadClass::transferConstantFieldOnCells( const ConstantFieldOnCellsRealPtr&
                                                                                        fieldIn,
                                                            ConstantFieldOnCellsRealPtr& fieldOut )

{
    const auto& toKeep = _FEDesc->getDelayedElementsToKeep();

    std::string savedName( "" );
    fieldOut->allocate( Permanent, fieldIn );
    for( int pos = 0; pos < (*fieldIn).size(); ++pos )
    {
        const auto& zone = fieldIn->getZoneDescription( pos );
        const auto& curFEDesc = zone.getFiniteElementDescriptor();
        if( curFEDesc->getName() != savedName && savedName != "" )
        {
            std::string a(
                "Different FiniteElementDescriptor in one ConstantFieldOnCells is not allowed");
            throw std::runtime_error( a );
        }
        savedName = curFEDesc->getName();

        VectorLong toCopy;
        for( const auto& num : zone.getListOfCells() )
        {
            if( toKeep[ -num - 1 ] != 1 )
                toCopy.push_back( toKeep[ -num - 1 ] );
        }
        if( toCopy.size() != 0 )
        {
            const auto newZone = ConstantFieldOnZone( zone.getFiniteElementDescriptor(), toCopy );
            const auto resu = fieldIn->getValues( pos );
            fieldOut->setValueOnZone( newZone, resu );
        }
    }
};

#endif /* _USE_MPI */
