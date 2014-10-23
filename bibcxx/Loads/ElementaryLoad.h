#ifndef ELEMENTARYLOAD_H_
#define ELEMENTARYLOAD_H_

#include "Modelisations/Model.h"
#include "DataFields/PCFieldOnMesh.h"
#include "aster.h"

/**
* class Elementary Load 
* Charge élémentaire constituée de
* - 1 type (correspondant au nom du mot-clé facteur : DDL_IMPO, PRES_REP) 
* - 1 nom  (correspondant au nom du mot-clé simple : DX, PRES)
* - 1 description (pas très importante) 
* - 1 valeur 
*/
template<class ValueType>
class ElementaryLoad
{
    private:
        // Nom du type de charge (DDL_IMPO, PRES_REP)
        string  _type;
        // Nom de la composante de la grandeur dont
        // la valeur est imposée,
        // ex : "DX", "PRES"
        string   _name;
        // Description de parametre, ex : "Pressure"
        string   _description;
        // Valeur du parametre (double, complex, fonction...)
        ValueType _value;

    public:
        /**
        * Constructeur
        * @param name Nom de la composante fixée  (ex : "DX")
        * @param description Description libre
        */
        ElementaryLoad(string type, string name, string description = ""):_type( type ),
                                                                          _name( name ),
                                                                          _description( description )
        {};
        /** Récupération du type de contrainte
        * @return le nom Aster du mot-clé facteur
        * définissant le type de contrainte 
        */
        const string& getType() const
        {
            return _type;
        };

        /**
        * Recuperation du nom de la composante fixée
        * @return le nom Aster du parametre
        */
        const string& getName() const
        {
            return _name;
        };

        /**
        * Recuperation de la valeur du parametre
        * @return renvoit la valeur du parametre
        */
        const ValueType & getValue() const

        {
            return _value;
        };

        /**
        * Fonction servant a fixer la valeur du parametre
        * @param currentValue valeur donnee par l'utilisateur
        */
        void setValue(ValueType & currentValue)
        {
            _value = currentValue;
        };
};

typedef class ElementaryLoad<double> ElementaryLoadDouble;

template<class ValueType>
class DisplacementLoad: public ElementaryLoad<ValueType>
{
    public:
        /**
        * Constructeur
        */
        DisplacementLoad<ValueType>(string name): ElementaryLoad<ValueType>( "DDL_IMPO", name, "Imposed displacement" )
        {};
};

template<class ValueType>
class PressureLoad: public ElementaryLoad<ValueType>
{
    public:
        /**
        * Constructeur
        */
        PressureLoad<ValueType>(): ElementaryLoad<ValueType>( "PRES_REP", "PRES", "Pressure" )
        {};
};

#endif /* ELEMENTARYLOAD_H_ */
