#ifndef FULLRESULTSCONTAINER_H_
#define FULLRESULTSCONTAINER_H_

/**
 * @file FullResultsContainer.h
 * @brief Fichier entete de la classe FullResultsContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/DynamicResultsIndexing.h"
#include "Results/ResultsContainer.h"
#include "Discretization/DOFNumbering.h"
#include "Supervis/ResultNaming.h"

/**
 * @class FullResultsContainerInstance
 * @brief Cette classe correspond à un sd_dyna_phys
 * @author Natacha Béreux
 */
class FullResultsContainerInstance: public ResultsContainerInstance
{
private:
    /** @brief indexage des résultats de calcul dynamiques */
    DynamicResultsIndexingPtr _index;
    /** @brief the support DOFNumbering */
    DOFNumberingPtr           _dofNum;

public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullResultsContainerInstance( const std::string &name, const std::string &resuTyp ):
        ResultsContainerInstance( name, resuTyp ),
        _index( new DynamicResultsIndexingInstance( name, resuTyp ) ),
        _dofNum( nullptr )
    {};

    FullResultsContainerInstance( const std::string &resuTyp ):
        FullResultsContainerInstance( ResultNaming::getNewResultName(), resuTyp )
    {};

    DOFNumberingPtr getDOFNumbering() const throw ( std::runtime_error )
    {
        if( _dofNum != nullptr )
            return _dofNum;
        throw std::runtime_error( "DOFNumbering is empty" );
    };

    bool printMedFile( std::string fileName ) const throw ( std::runtime_error )
    {
        return ResultsContainerInstance::printMedFile( fileName );
    };

    bool setDOFNumbering( const DOFNumberingPtr& dofNum )
    {
        if( dofNum != nullptr )
        {
            _dofNum = dofNum;
            if( _dofNum->getSupportModel() != nullptr )
                _mesh = _dofNum->getSupportModel()->getSupportMesh();
            _fieldBuidler.addFieldOnNodesDescription( _dofNum->getFieldOnNodesDescription() );
            return true;
        }
        return false;
    };
};

/**
 * @typedef FullResultsContainerPtr
 * @brief Pointeur intelligent vers un FullResultsContainerInstance
 */
typedef boost::shared_ptr< FullResultsContainerInstance > FullResultsContainerPtr;

#endif /* FULLRESULTSCONTAINER_H_ */
