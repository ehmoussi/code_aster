#ifndef DOFNUMBERING_H_
#define DOFNUMBERING_H_

/**
 * @file BaseDOFNumbering.h
 * @brief Fichier entete de la classe BaseDOFNumbering
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
 *   This file is part of code_aster.
 *
 *   code_aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   code_aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 */

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>
#include "astercxx.h"
#include <string>

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/ListOfLoads.h"

/**
 * @class BaseDOFNumberingInstance
 * @brief Class definissant un nume_ddl
 *        Cette classe est volontairement succinte car on n'en connait pas encore l'usage
 * @author Nicolas Sellenet
 */
class BaseDOFNumberingInstance: public DataStructure
{
private:
    class GlobalEquationNumberingInstance
    {
        /** @brief Objet Jeveux '.NEQU' */
        JeveuxVectorLong       _numberOfEquations;
        /** @brief Objet Jeveux '.REFN' */
        JeveuxVectorLong       _informations;
        /** @brief Objet Jeveux '.DELG' */
        JeveuxVectorLong       _lagrangianInformations;
        /** @brief Objet Jeveux '.PRNO' */
        JeveuxCollectionLong   _componentsOnNodes;
        /** @brief Objet Jeveux '.LILI' */
        JeveuxBidirectionalMap _namesOfGroupOfElements;
        /** @brief Objet Jeveux '.NUEQ' */
        JeveuxVectorLong       _indexationVector;
        /** @brief Objet Jeveux '.DEEQ' */
        JeveuxVectorLong       _nodeAndComponentsNumberFromDOF;

        GlobalEquationNumberingInstance( const std::string& DOFNumName ):
            _numberOfEquations( DOFNumName + ".NEQU" ),
            _informations( DOFNumName + ".REFN" ),
            _lagrangianInformations( DOFNumName + ".DELG" ),
            _componentsOnNodes( DOFNumName + ".PRNO" ),
            _namesOfGroupOfElements( DOFNumName + ".LILI" ),
            _indexationVector( DOFNumName + ".NUEQ" ),
            _nodeAndComponentsNumberFromDOF( DOFNumName + ".DEEQ" )
        {
            if ( DOFNumName.size() != 19 )
                throw std::runtime_error( "Catastrophic error" );
        };
        friend class BaseDOFNumberingInstance;
    };
    typedef boost::shared_ptr< GlobalEquationNumberingInstance > GlobalEquationNumberingPtr;

    class LocalEquationNumberingInstance
    {
        /** @brief Objet Jeveux '.NEQU' */
        JeveuxVectorLong     _numberOfEquations;
        /** @brief Objet Jeveux '.DELG' */
        JeveuxVectorLong     _lagrangianInformations;
        /** @brief Objet Jeveux '.PRNO' */
        JeveuxCollectionLong _componentsOnNodes;
        /** @brief Objet Jeveux '.NUEQ' */
        JeveuxVectorLong     _indexationVector;
        /** @brief Objet Jeveux '.NEQU' */
        JeveuxVectorLong     _globalToLocal;
        /** @brief Objet Jeveux '.DELG' */
        JeveuxVectorLong     _LocalToGlobal;

        LocalEquationNumberingInstance( const std::string& DOFNumName ):
            _numberOfEquations( DOFNumName + ".NEQU" ),
            _lagrangianInformations( DOFNumName + ".DELG" ),
            _componentsOnNodes( DOFNumName + ".PRNO" ),
            _indexationVector( DOFNumName + ".NUEQ" ),
            _globalToLocal( DOFNumName + ".NULG" ),
            _LocalToGlobal( DOFNumName + ".NUGL" )
        {
            if ( DOFNumName.size() != 19 )
                throw std::runtime_error( "Catastrophic error" );
        };
        friend class BaseDOFNumberingInstance;
    };
    typedef boost::shared_ptr< LocalEquationNumberingInstance > LocalEquationNumberingPtr;

    // !!! Classe succinte car on ne sait pas comment elle sera utiliser !!!
    /** @brief Objet Jeveux '.NSLV' */
    JeveuxVectorChar24         _nameOfSolverDataStructure;
    /** @brief Objet '.NUME' */
    GlobalEquationNumberingPtr _globalNumbering;
    /** @brief Objet '.NUML' */
    LocalEquationNumberingPtr  _localNumbering;
    /** @brief Modele support */
    ModelPtr                   _supportModel;
    /** @brief Matrices elementaires */
    ElementaryMatrixPtr        _supportMatrix;
    /** @brief Chargements */
    ListOfLoadsPtr             _listOfLoads;
    /** @brief Booleen permettant de preciser sur la sd est vide */
    bool                       _isEmpty;

protected:
    /**
     * @brief Constructeur
     */
    BaseDOFNumberingInstance( const std::string& type,
                              const JeveuxMemory memType = Permanent );

    /**
     * @brief Constructeur
     * @param name nom souhaité de la sd (utile pour le BaseDOFNumberingInstance d'une sd_resu)
     */
    BaseDOFNumberingInstance( const std::string name,
                              const std::string& type,
                              const JeveuxMemory memType = Permanent );

public:
    /**
     * @brief Destructeur
     */
    ~BaseDOFNumberingInstance()
    {
#ifdef __DEBUG_GC__
        std::cout << "BaseDOFNumberingInstance.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @typedef BaseDOFNumberingPtr
     * @brief Pointeur intelligent vers un BaseDOFNumbering
     */
    typedef boost::shared_ptr< BaseDOFNumberingInstance > BaseDOFNumberingPtr;

    /**
     * @brief Function d'ajout d'une charge cinematique
     * @param currentLoad charge a ajouter a la sd
     */
    void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
    {
        _listOfLoads->addKinematicsLoad( currentLoad );
    };

    /**
     * @brief Function d'ajout d'une charge mecanique
     * @param currentLoad charge a ajouter a la sd
     */
    void addMechanicalLoad( const GenericMechanicalLoadPtr& currentLoad )
    {
        _listOfLoads->addMechanicalLoad( currentLoad );
    };

    /**
     * @brief Determination de la numerotation
     */
    bool computeNumerotation() throw ( std::runtime_error );

    /**
     * @brief Methode permettant de savoir si la numerotation est vide
     * @return true si la numerotation est vide
     */
    bool isEmpty()
    {
        return _isEmpty;
    };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    virtual void setElementaryMatrix( const ElementaryMatrixPtr& currentMatrix )
        throw ( std::runtime_error )
    {
        if ( _supportModel )
            throw std::runtime_error( "It is not allowed to defined Model and ElementaryMatrix together" );
        _supportMatrix = currentMatrix;
    };

    /**
     * @brief Methode permettant de definir la liste de charge
     * @param currentList Liste charge
     */
    void setListOfLoads( const ListOfLoadsPtr& currentList  )
    {
        _listOfLoads = currentList;
    };

    /**
     * @brief Methode permettant de definir le modele support
     * @param currentModel Model support de la numerotation
     */
    virtual void setSupportModel( const ModelPtr& currentModel )
        throw ( std::runtime_error )
    {
        if ( ! _supportMatrix.use_count() == 0 )
            throw std::runtime_error( "It is not allowed to defined Model and ElementaryMatrix together" );
        _supportModel = currentModel;
    };
};

/**
 * @class DOFNumberingInstance
 * @brief Class definissant un nume_ddl
 * @author Nicolas Sellenet
 */
class DOFNumberingInstance: public BaseDOFNumberingInstance
{
public:
    /**
     * @typedef DOFNumberingPtr
     * @brief Pointeur intelligent vers un DOFNumbering
     */
    typedef boost::shared_ptr< DOFNumberingInstance > DOFNumberingPtr;

    /**
     * @brief Constructeur
     */
    static DOFNumberingPtr create()
    {
        return DOFNumberingPtr( new DOFNumberingInstance );
    };

    /**
     * @brief Constructeur
     */
    DOFNumberingInstance( const JeveuxMemory memType = Permanent ):
        BaseDOFNumberingInstance( "NUME_DDL", memType )
    {};

    /**
     * @brief Constructeur
     * @param name nom souhaité de la sd (utile pour le BaseDOFNumberingInstance d'une sd_resu)
     */
    DOFNumberingInstance( const std::string name, const JeveuxMemory memType = Permanent ):
        BaseDOFNumberingInstance( name, "NUME_DDL", memType )
    {};

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    void setElementaryMatrix( const ElementaryMatrixPtr& currentMatrix )
        throw ( std::runtime_error )
    {
        if( currentMatrix->getSupportModel()->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must not be parallel" );
        BaseDOFNumberingInstance::setElementaryMatrix( currentMatrix );
    };

    /**
     * @brief Methode permettant de definir le modele support
     * @param currentModel Model support de la numerotation
     */
    void setSupportModel( const ModelPtr& currentModel )
        throw ( std::runtime_error )
    {
        if( currentModel->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must not be parallel" );
        BaseDOFNumberingInstance::setSupportModel( currentModel );
    };
};

/**
 * @typedef BaseDOFNumberingPtr
 * @brief Enveloppe d'un pointeur intelligent vers un BaseDOFNumberingInstance
 * @author Nicolas Sellenet
 */
typedef boost::shared_ptr< BaseDOFNumberingInstance > BaseDOFNumberingPtr;


/**
 * @typedef DOFNumberingPtr
 * @brief Enveloppe d'un pointeur intelligent vers un DOFNumberingInstance
 * @author Nicolas Sellenet
 */
typedef boost::shared_ptr< DOFNumberingInstance > DOFNumberingPtr;

#endif /* DOFNUMBERING_H_ */
