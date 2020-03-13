#ifndef LISTOFLOADS_H_
#define LISTOFLOADS_H_

/**
 * @file ListOfLoads.h
 * @brief Fichier entete de la classe ListOfLoads
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

#include <stdexcept>
#include <list>
#include <string>

#include "astercxx.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/ParallelMechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "Functions/Function.h"
#include "Functions/Formula.h"
#include "Functions/Function2D.h"
#include "boost/variant.hpp"
#include "MemoryManager/JeveuxVector.h"

class GenericLoadFunction {
  private:
    boost::variant< FunctionPtr, FormulaPtr, Function2DPtr > _generic;

  public:
    GenericLoadFunction( const FunctionPtr &func ) : _generic( func ){};

    GenericLoadFunction( const FormulaPtr &func ) : _generic( func ){};

    GenericLoadFunction( const Function2DPtr &func ) : _generic( func ){};

    std::string getName() const {
        if ( _generic.type() == typeid( FunctionPtr ) )
            return boost::get< FunctionPtr >( _generic )->getName();
        if ( _generic.type() == typeid( FormulaPtr ) )
            return boost::get< FormulaPtr >( _generic )->getName();
        if ( _generic.type() == typeid( Function2DPtr ) )
            return boost::get< Function2DPtr >( _generic )->getName();
    };
};

typedef std::vector< GenericLoadFunction > ListOfLoadFunctions;

/**
 * @class ListOfLoadClass
 * @brief Classe definissant une liste de charge
 * @author Nicolas Sellenet
 */
class ListOfLoadsClass : public DataStructure {
  private:
    /** @brief Chargements cinematiques */
    ListKineLoad _listOfKinematicsLoads;
    /** @brief List of functions for KinematicsLoads */
    ListOfLoadFunctions _listOfKineFun;
    /** @brief Chargements Mecaniques */
    ListMecaLoad _listOfMechanicalLoads;
    /** @brief List of functions for MechanicalLoads */
    ListOfLoadFunctions _listOfMechaFun;
#ifdef _USE_MPI
    /** @brief Chargements Mecaniques paralleles */
    ListParaMecaLoad _listOfParallelMechanicalLoads;
    /** @brief List of functions for ParallelMechanicalLoads */
    ListOfLoadFunctions _listOfParaMechaFun;
#endif /* _USE_MPI */
    /** @brief .INFC */
    JeveuxVectorLong _loadInformations;
    /** @brief .LCHA */
    JeveuxVectorChar24 _list;
    /** @brief .FCHA */
    JeveuxVectorChar24 _listOfFunctions;
    /** @brief La chargement est-il vide ? */
    bool _isEmpty;

  public:
    /**
     * @brief Constructeur
     */
    ListOfLoadsClass( const JeveuxMemory memType = Permanent );

    /**
     * @brief Function d'ajout d'une charge cinematique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function
     */
    void addLoad( const KinematicsLoadPtr &currentLoad,
                  const FunctionPtr &func = emptyRealFunction ) {
        _isEmpty = true;
        _listOfKinematicsLoads.push_back( currentLoad );
        _listOfKineFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge cinematique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier formula
     */
    void addLoad( const KinematicsLoadPtr &currentLoad, const FormulaPtr &func ) {
        _isEmpty = true;
        _listOfKinematicsLoads.push_back( currentLoad );
        _listOfKineFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge cinematique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function2d
     */
    void addLoad( const KinematicsLoadPtr &currentLoad, const Function2DPtr &func ) {
        _isEmpty = true;
        _listOfKinematicsLoads.push_back( currentLoad );
        _listOfKineFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function
     */
    void addLoad( const GenericMechanicalLoadPtr &currentLoad,
                  const FunctionPtr &func = emptyRealFunction ) {
        _isEmpty = true;
        _listOfMechanicalLoads.push_back( currentLoad );
        _listOfMechaFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier formula
     */
    void addLoad( const GenericMechanicalLoadPtr &currentLoad, const FormulaPtr &func ) {
        _isEmpty = true;
        _listOfMechanicalLoads.push_back( currentLoad );
        _listOfMechaFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function2d
     */
    void addLoad( const GenericMechanicalLoadPtr &currentLoad, const Function2DPtr &func ) {
        _isEmpty = true;
        _listOfMechanicalLoads.push_back( currentLoad );
        _listOfMechaFun.push_back( func );
    };

#ifdef _USE_MPI
    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function
     */
    void addLoad( const ParallelMechanicalLoadPtr &currentLoad,
                  const FunctionPtr &func = emptyRealFunction ) {
        _isEmpty = true;
        _listOfParallelMechanicalLoads.push_back( currentLoad );
        _listOfParaMechaFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier formula
     */
    void addLoad( const ParallelMechanicalLoadPtr &currentLoad, const FormulaPtr &func ) {
        _isEmpty = true;
        _listOfParallelMechanicalLoads.push_back( currentLoad );
        _listOfParaMechaFun.push_back( func );
    };

    /**
     * @brief Function d'ajout d'une charge mécanique
     * @param currentLoad charge a ajouter a la sd
     * @param func multiplier function2d
     */
    void addLoad( const ParallelMechanicalLoadPtr &currentLoad, const Function2DPtr &func ) {
        _isEmpty = true;
        _listOfParallelMechanicalLoads.push_back( currentLoad );
        _listOfParaMechaFun.push_back( func );
    };
#endif /* _USE_MPI */

    /**
     * @brief Construction de la liste de charge
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool build() ;

    /**
    * @brief Construction de la liste des charges pour valoriser le mot-clé facteur EXCIT de
    * STAT_NON_LINE . C'est une méthode temporaire
    * @return listExcit
    */
    ListSyntaxMapContainer buildListExcit() ;

    /**
     * @brief Function de récupération des informations des charges
     * @return _loadInformations
     */
    const JeveuxVectorLong &getInformationVector() const { return _loadInformations; };

    /**
     * @brief Function de récupération de la liste des fonctions multiplicatrices
     * @return _listOfFunctions
     */
    const JeveuxVectorChar24 &getListOfFunctions() const { return _listOfFunctions; };

    /**
     * @brief Function de récupération de la liste des charges cinématiques
     * @return _listOfKinematicsLoads
     */
    const ListKineLoad &getListOfKinematicsLoads() const { return _listOfKinematicsLoads; };

    /**
     * @brief Function de récupération de la liste des charges mécaniques
     * @return _listOfMechanicalLoads
     */
    const ListMecaLoad &getListOfMechanicalLoads() const { return _listOfMechanicalLoads; };

#ifdef _USE_MPI
    /**
     * @brief Function de récupération de la liste des charges mécaniques
     * @return _listOfMechanicalLoads
     */
    const ListParaMecaLoad &getListOfParallelMechanicalLoads() const {
        return _listOfParallelMechanicalLoads;
    };
#endif /* _USE_MPI */

    /**
     * @brief Function de récupération de la liste des charges
     * @return _list
     */
    const JeveuxVectorChar24 &getListVector() const { return _list; };

    /**
     * @brief Methode permettant de savoir si la matrice est vide
     * @return true si vide
     */
    bool isEmpty() { return _isEmpty; };

    /**
     * @brief Nombre de charges
     * @return taille de _listOfMechanicalLoads + taille de _listOfKinematicsLoads
     */
    int size() const { return _listOfMechanicalLoads.size() + _listOfKinematicsLoads.size(); };
};

/**
 * @typedef ListOfLoad
 * @brief Pointeur intelligent vers un ListOfLoadClass
 */
typedef boost::shared_ptr< ListOfLoadsClass > ListOfLoadsPtr;

#endif /* LISTOFLOADS_H_ */
