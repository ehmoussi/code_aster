#ifndef MECHANICALLOAD_H_
#define MECHANICALLOAD_H_

#include "DataStructure/DataStructure.h"
#include "Loads/ElementaryLoad.h"
#include "Modelisations/Model.h"
#include "DataFields/PCFieldOnMesh.h"
#include "aster.h"

/**
* class MechanicalLoadInstance 
*   Cette classe contient le wrapper vers la sd_affe_char_meca
*   ainsi que la liste des contraintes (i.e des paires (contrainte élémentaire, groupe))
*   définies par l'utilisateur 
*/
class MechanicalLoadInstance : public DataStructure 
{
    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        typedef list< pair< ElementaryLoadDouble, MeshEntityPtr > > listOfLoadsAndGrpsDouble;
        typedef listOfLoadsAndGrpsDouble::value_type listOfLoadsAndGrpsDoubleValue;
        typedef listOfLoadsAndGrpsDouble::iterator listOfLoadsAndGrpsDoubleIter;
// Accès à la sd_affe_char_meca 
        const string          _jeveuxName;
        PCFieldOnMeshDouble   _cinematicLoad;
        PCFieldOnMeshDouble   _pressure;
// Description utilisateur des charges imposées
        listOfLoadsAndGrpsDouble    _listOfLoadsDouble;
        Model                       _supportModel;

    public:
        /**
        * Constructeur
        */
        MechanicalLoadInstance();

// Imposer un déplacement (e.g. DX = 0 ) sur un groupe de noeuds (défini par son nom) 
        void setDisplacementOnNodes(string doFName, double doFValue, string nameOfGroup)
        {
// Vérifier que le nom de groupe est licite (i.e. le nom définit bien un groupe de noeuds qui 
// existe dans le maillage sous-jacent au modèle.
            Mesh & currentMesh= _supportModel->getSupportMesh();
            if ( !currentMesh->hasGroupOfNodes( nameOfGroup )) 
            {
                throw "The group does not exist in the mesh you provided";
            }
            DisplacementLoad<double> currentDispl( doFName );
            currentDispl.setValue( doFValue );
            _listOfLoadsDouble.push_back( listOfLoadsAndGrpsDouble:: value_type(currentDispl,
                                          MeshEntityPtr( new GroupOfNodesInstance( nameOfGroup ) ) ) );
        };

// Imposer un déplacement (e.g. DX = 0 ) sur un groupe de mailles (défini par son nom) 
        void setDisplacementOnElements(string doFName, double doFValue, string nameOfGroup)  
        {
// Vérifier que le nom de groupe est licite (i.e. le nom définit bien un groupe de mailles qui 
// existe dans le maillage sous-jacent au modèle.
            Mesh & currentMesh= _supportModel->getSupportMesh();
            if ( !currentMesh->hasGroupOfElements( nameOfGroup )) 
            {
                throw "The group does not exist in the mesh you provided";
            }
            DisplacementLoad<double> currentDispl( doFName );
            currentDispl.setValue( doFValue );
            _listOfLoadsDouble.push_back( listOfLoadsAndGrpsDouble:: value_type(currentDispl,
                                          MeshEntityPtr( new GroupOfElementsInstance( nameOfGroup ) ) ) );
        };

// Imposer une pression sur un groupe de mailles
        void setPressureOnElements(double pressure_value, string nameOfGroup)
        {
// Vérifier que le nom de groupe est licite (i.e. le nom définit bien un groupe de mailles qui 
// existe dans le maillage sous-jacent au modèle.
            Mesh & currentMesh= _supportModel->getSupportMesh();
            if ( !currentMesh->hasGroupOfElements( nameOfGroup )) 
            {
                throw "The group does not exist in the mesh you provided";
            }
            PressureLoad<double> currentPres;
            currentPres.setValue( pressure_value);
            _listOfLoadsDouble.push_back( listOfLoadsAndGrpsDouble:: value_type( currentPres,
                                          MeshEntityPtr( new GroupOfElementsInstance( nameOfGroup ) ) ) );
        };

        bool build();

// Définir le modèle support
        bool setSupportModel(Model& currentModel)
        {
            if ( currentModel.isEmpty() )
                throw string("Model is empty");
            _supportModel = currentModel;
            return true;
        };
};

class MechanicalLoad 
{
    public:
        typedef boost::shared_ptr< MechanicalLoadInstance > MechanicalLoadPtr;

    private:
        MechanicalLoadPtr _MechanicalLoadPtr;

    public:
        MechanicalLoad(bool initialisation = true): _MechanicalLoadPtr()
        {
            if ( initialisation == true )
                _MechanicalLoadPtr = MechanicalLoadPtr( new MechanicalLoadInstance() );
        };

        ~MechanicalLoad()
        {};

        MechanicalLoad& operator=(const MechanicalLoad& tmp)
        {
            _MechanicalLoadPtr = tmp._MechanicalLoadPtr;
            return(*this);
        };

        const MechanicalLoadPtr& operator->() const
        {
            return _MechanicalLoadPtr;
        };

        bool isEmpty() const
        {
            if ( _MechanicalLoadPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MECHANICALLOAD_H_ */
