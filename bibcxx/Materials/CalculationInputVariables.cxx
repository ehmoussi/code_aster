/**
 * @file CalculationInputVariables.cxx
 * @brief Implementation de CalculationInputVariablesInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Materials/CalculationInputVariables.h"

CalculationInputVariablesInstance::CalculationInputVariablesInstance(
    const ModelPtr &model, const MaterialOnMeshPtr &mater,
    const ElementaryCharacteristicsPtr &cara, const CodedMaterialPtr &codMater ):
        DataStructure( "VARI_COM", Permanent, 14 ), _model( model ), _mater( mater ),
        _codMater( codMater ), _elemCara( cara ),
        _varRef( new FieldOnElementsDoubleInstance( _model->getName() + ".CHVCREF" ) ),
        _varInst( new FieldOnElementsDoubleInstance( getName() + ".TOUT" ) ),
        _timeValue(
          new PCFieldOnMeshDoubleInstance( getName() + ".INST", _model->getSupportMesh() ) ),
        _currentTime( -1.0 ), _pTot( _mater->existsCalculationInputVariable( "PTOT" ) ),
        _hydr( _mater->existsCalculationInputVariable( "HYDR" ) ),
        _sech( _mater->existsCalculationInputVariable( "SECH" ) ),
        _temp( _mater->existsCalculationInputVariable( "TEMP" ) )
{
    std::string modName( _model->getName(), 0, 8 ), matName( _mater->getName(), 0, 8 );
    std::string carName( ' ', 8 );
    if ( _elemCara != nullptr )
        carName = std::string( _elemCara->getName(), 0, 8 );
    CALLO_VRCREF( modName, matName, carName, _varRef->getName() );
};

void CalculationInputVariablesInstance::compute( const double &time )
{
    _currentTime = time;
    _varInst->deallocate();
    _timeValue->deallocate();

    std::string modName( _model->getName(), 0, 8 ), matName( _mater->getName(), 0, 8 );
    std::string carName( 8, ' ' );
    if ( _elemCara != nullptr )
        carName = std::string( _elemCara->getName(), 0, 8 );
    std::string out( ' ', 2 );
    CALLO_VRCINS_WRAP( modName, matName, carName, &time, _varInst->getName(), out );

    std::string comp( "INST_R" );
    _timeValue->allocate( Permanent, comp );
    PCFieldZone a( _model->getSupportMesh() );
    PCFieldValues< double > b( {"INST"}, {time} );
    _timeValue->setValueOnZone( a, b );
};

FieldOnNodesDoublePtr
CalculationInputVariablesInstance::computeMechanicalLoads( const BaseDOFNumberingPtr &dofNUM )
{
    const auto &codedMater = _codMater->getCodedMaterialField();
    std::string modName( _model->getName(), 0, 8 );
    std::string carName( 8, ' ' );
    if ( _elemCara != nullptr )
        carName = std::string( _elemCara->getName(), 0, 8 );

    const auto compor = _mater->getBehaviourField();
    std::string numName( dofNUM->getName() ), out( 24, ' ' );
    ASTERINTEGER a = 0, b = 0, c = 0, d = 0;
    if ( _hydr )
        a = 1;
    if ( _sech )
        b = 1;
    if ( _temp )
        c = 1;
    if ( _pTot )
        d = 1;
    CALLO_CACHVC( modName, codedMater->getName(), carName, numName, compor->getName(), getName(),
                  out, &a, &b, &c, &d );
    JeveuxVectorChar24 vectOut( out );
    vectOut->updateValuePointer();
    FieldOnNodesDoublePtr toReturn( new FieldOnNodesDoubleInstance( ( *vectOut )[0].toString() ) );
    toReturn->updateValuePointers();
    return toReturn;
};
