#ifndef RESULTS_H_
#define RESULTS_H_

/**
 * @file Result.h
 * @brief Fichier entete de la classe Result
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "Meshes/Mesh.h"
#include "Modeling/Model.h"
#include "Materials/MaterialField.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "DataFields/FieldOnNodes.h"
#include "DataFields/FieldOnCells.h"
#include "Numbering/DOFNumbering.h"
#include "Numbering/ParallelDOFNumbering.h"
#include "Supervis/ResultNaming.h"
#include "Discretization/ElementaryCharacteristics.h"
#include "Loads/ListOfLoads.h"
#include "DataFields/FieldBuilder.h"

/**
 * @class ResultClass
 * @brief Cette classe correspond a la sd_resultat de Code_Aster, elle stocke des champs
 * @author Nicolas Sellenet
 */
class ResultClass : public DataStructure {
  private:
    typedef std::vector< FieldOnNodesRealPtr > VectorOfFieldsNodes;
    typedef std::vector< FieldOnCellsRealPtr > VectorOfFieldsCells;

    /** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
    typedef std::map< std::string, VectorOfFieldsNodes > mapStrVOFN;
    /** @typedef Iterateur sur le std::map */
    typedef mapStrVOFN::iterator mapStrVOFNIterator;
    /** @typedef Valeur contenue dans mapStrVOFN */
    typedef mapStrVOFN::value_type mapStrVOFNValue;

    /** @typedef std::map du rang et des pointers vers ElementaryCharacteristicsPtr */
    typedef std::map< int, ElementaryCharacteristicsPtr > mapRankCaraElem;
    /** @typedef std::map du rang et des pointers vers ListOfLoadsPtr */
    typedef std::map< int, ListOfLoadsPtr > mapRankLoads;
    /** @typedef std::map du rang et des pointers vers MaterialFieldPtr */
    typedef std::map< int, MaterialFieldPtr > mapRankMaterial;
    /** @typedef std::map du rang et des pointers vers ModelPtr */
    typedef std::map< int, ModelPtr > mapRankModel;

    /** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
    typedef std::map< std::string, VectorOfFieldsCells > mapStrVOFE;
    /** @typedef Iterateur sur le std::map */
    typedef mapStrVOFE::iterator mapStrVOFEIterator;
    /** @typedef Valeur contenue dans mapStrVOFE */
    typedef mapStrVOFE::value_type mapStrVOFEValue;
    /** @brief Pointeur de nom Jeveux '.DESC' */
    JeveuxBidirectionalMapChar16 _symbolicNamesOfFields;
    /** @brief Collection '.TACH' */
    JeveuxCollectionChar24 _namesOfFields;
    /** @brief Pointeur de nom Jeveux '.NOVA' */
    JeveuxBidirectionalMapChar16 _accessVariables;
    /** @brief Collection '.TAVA' */
    JeveuxCollectionChar8 _calculationParameter;
    /** @brief Vecteur Jeveux '.ORDR' */
    JeveuxVectorLong _serialNumber;
    /** @brief Nombre de numéros d'ordre */
    int _nbRanks;
    /** @brief Vecteur Jeveux '.RSPI' */
    JeveuxVectorLong _rspi;
    /** @brief Vecteur Jeveux '.RSPR' */
    JeveuxVectorReal _rspr;
    /** @brief Vecteur Jeveux '.RSP8' */
    JeveuxVectorChar8 _rsp8;
    /** @brief Vecteur Jeveux '.RS16' */
    JeveuxVectorChar16 _rs16;
    /** @brief Vecteur Jeveux '.RS24' */
    JeveuxVectorChar24 _rs24;
    /** @brief jeveux vector '.TITR' */
    JeveuxVectorChar80 _title;

    /** @brief Liste des champs aux noeuds */
    mapStrVOFN _dictOfVectorOfFieldsNodes;
    /** @brief Liste des champs aux éléments */
    mapStrVOFE _dictOfVectorOfFieldsCells;
    /** @brief Liste des NUME_DDL */
    std::vector< BaseDOFNumberingPtr > _listOfDOFNum;
    /** @brief List of ElementaryCharacteristicsPtr */
    mapRankCaraElem _mapElemCara;
    /** @brief List of ListOfLoadsPtr */
    mapRankLoads _mapLoads;
    /** @brief List of MaterialFieldPtr */
    mapRankMaterial _mapMaterial;
    /** @brief List of ModelPtr */
    mapRankModel _mapModel;

  protected:
    /** @brief Maillage sur lequel repose la resultat */
    BaseMeshPtr _mesh;
    /** @brief Object to correctly manage fields and field descriptions */
    FieldBuilder _fieldBuidler;

  public:
    /**
     * @typedef ResultPtr
     * @brief Pointeur intelligent vers un ResultClass
     */
    typedef boost::shared_ptr< ResultClass > ResultPtr;

    /**
     * @brief Constructeur
     */
    ResultClass( const std::string &resuTyp )
        : ResultClass( ResultNaming::getNewResultName(), resuTyp ){};

    /**
     * @brief Constructeur
     */
    ResultClass( const std::string &name, const std::string &resuTyp )
        : DataStructure( name, 19, resuTyp ),
          _symbolicNamesOfFields( JeveuxBidirectionalMapChar16( getName() + ".DESC" ) ),
          _namesOfFields( JeveuxCollectionChar24( getName() + ".TACH" ) ),
          _accessVariables( JeveuxBidirectionalMapChar16( getName() + ".NOVA" ) ),
          _calculationParameter( JeveuxCollectionChar8( getName() + ".TAVA" ) ),
          _serialNumber( JeveuxVectorLong( getName() + ".ORDR" ) ), _nbRanks( 0 ),
          _rspi( JeveuxVectorLong( getName() + ".RSPI" ) ),
          _rspr( JeveuxVectorReal( getName() + ".RSPR" ) ),
          _rsp8( JeveuxVectorChar8( getName() + ".RSP8" ) ),
          _rs16( JeveuxVectorChar16( getName() + ".RS16" ) ),
          _rs24( JeveuxVectorChar24( getName() + ".RS24" ) ),
          _title( JeveuxVectorChar80( getName() + ".TITR" ) ), _mesh( nullptr ),
          _fieldBuidler( FieldBuilder() ){};

    /**
     * @brief Allouer une sd_resultat
     * @param nbRanks nombre de numéro d'ordre
     * @return true si l'allocation s'est bien passée
     */
    bool allocate( int nbRanks ) ;

    /**
     * @brief Add elementary characteristics to container
     * @param rank
     */
    void addElementaryCharacteristics( const ElementaryCharacteristicsPtr &,
                                       int rank ) ;

    /**
     * @brief Add a existing FieldOnNodesDescription in _fieldBuidler
     */
    void addFieldOnNodesDescription( const FieldOnNodesDescriptionPtr &fond )
    {
        _fieldBuidler.addFieldOnNodesDescription( fond );
    };

    /**
     * @brief Add elementary characteristics to container
     * @param rank
     */
    void addListOfLoads( const ListOfLoadsPtr &, int rank ) ;

    /**
     * @brief Add material definition
     * @param rank
     */
    void addMaterialField( const MaterialFieldPtr &, int rank ) ;

    /**
     * @brief Add model
     * @param rank
     */
    void addModel( const ModelPtr &, int rank ) ;

    /**
     * @brief Set model
     */
    void setMesh( const BaseMeshPtr &mesh ) { _mesh = mesh; };

    /**
     * @brief Add time value for one rank
     * @param rank
     */
    void addTimeValue( double, int rank );

    /**
     * @brief Append a elementary characteristics on all rank of Result
     * @param ElementaryCharacteristicsPtr
     */
    void appendElementaryCharacteristicsOnAllRanks( const ElementaryCharacteristicsPtr& );

    /**
     * @brief Append a material on all rank of Result
     * @param MaterialFieldPtr
     */
    void appendMaterialFieldOnAllRanks( const MaterialFieldPtr & );

    /**
     * @brief Append a model on all rank of Result
     * @param ModelPtr
     */
    void appendModelOnAllRanks( const ModelPtr & );

    /**
     * @brief Obtenir un DOFNumbering à remplir
     * @return DOFNumbering à remplir
     */
    BaseDOFNumberingPtr getEmptyDOFNumbering();

/**
 * @brief Obtenir un DOFNumbering à remplir
 * @return DOFNumbering à remplir
 */
#ifdef _USE_MPI
    BaseDOFNumberingPtr getEmptyParallelDOFNumbering();
#endif /* _USE_MPI */

    /**
     * @brief Obtenir un champ aux noeuds réel vide à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnNodesRealPtr pointant vers le champ
     */
    FieldOnNodesRealPtr getEmptyFieldOnNodesReal( const std::string name,
                                                      const int rank ) ;

    /**
     * @brief Obtenir le dernier DOFNumbering
     * @return Dernier DOFNumbering
     */
    BaseDOFNumberingPtr getLastDOFNumbering() const {
        return _listOfDOFNum[_listOfDOFNum.size() - 1];
    };

    /**
     * @brief Add elementary characteristics to container
     * @param rank
     */
    ListOfLoadsPtr getListOfLoads( int rank ) ;

    /**
     * @brief Get elementary characteristics
     */
    ElementaryCharacteristicsPtr
    getElementaryCharacteristics() ;

    /**
     * @brief Get elementary characteristics
     * @param rank
     */
    ElementaryCharacteristicsPtr
    getElementaryCharacteristics( int rank ) ;

    /**
     * @brief Get material
     */
    MaterialFieldPtr getMaterialField() ;

    /**
     * @brief Get material
     * @param rank
     */
    MaterialFieldPtr getMaterialField( int rank ) ;

    /**
     * @brief Get mesh
     */
    BaseMeshPtr getMesh();

    /**
     * @brief Get model
     */
    ModelPtr getModel() ;

    /**
     * @brief Get model
     * @param rank
     */
    ModelPtr getModel( int rank ) ;

    /**
     * @brief Obtenir un champ aux noeuds réel à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnCellsRealPtr pointant vers le champ
     */
    FieldOnCellsRealPtr getRealFieldOnCells( const std::string name, const int rank ) const
        ;

    /**
     * @brief Obtenir un champ aux noeuds réel à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnNodesRealPtr pointant vers le champ
     */
    FieldOnNodesRealPtr getRealFieldOnNodes( const std::string name, const int rank ) const
        ;

    /**
     * @brief Impression de la sd au format MED
     * @param fileName Nom du fichier MED à imprimer
     * @return true
     * @todo revoir la gestion des mot-clés par défaut (ex : TOUT_ORDRE)
     * @todo revoir la gestion des unités logiques (notamment si fort.20 existe déjà)
     */
    bool printMedFile( std::string fileName ) const ;

    /**
    * @brief Get the number of steps stored in the Result
    * @return nbRanks
    */
    int getNumberOfRanks() const;

    /**
    * @brief Get the number of steps stored in the Result
    * @return nbRanks
    */
    std::vector< long > getRanks() const;

    /**
    * @brief Print all the fields stored in the Result
    * @return nbRanks
    */
    void listFields() const;

    /**
     * @brief Construire une sd_resultat à partir d'objet produit dans le Fortran
     * @return true si l'allocation s'est bien passée
     * @todo revoir l'agrandissement de dictOfVectorOfFieldsNodes et dictOfVectorOfFieldsCells
     */
    bool update() ;
};

/**
 * @typedef ResultPtr
 * @brief Pointeur intelligent vers un ResultClass
 */
typedef boost::shared_ptr< ResultClass > ResultPtr;

#endif /* RESULTS_H_ */
