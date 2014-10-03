#ifndef JEVEUXBIDIRECTIONALMAP_H_
#define JEVEUXBIDIRECTIONALMAP_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "command/Initializer.h"

using namespace std;

/**
* class JeveuxBidirectionalMapInstance
*   Equivalent du pointeur de nom dans Jeveux
*   Un pointeur de nom permet de creer une correspondance entre
*   une chaine de caractere et un entier (et inversement)
* @author Nicolas Sellenet
*/
class JeveuxBidirectionalMapInstance
{
    private:
        // Nom Jeveux de l'objet
        string _jeveuxName;

    public:
        /**
        * Constructeur
        * @param name Nom Jeveux de l'objet
        */
        JeveuxBidirectionalMapInstance(string name): _jeveuxName(name)
        {};

        /**
        * Recuperation de la chaine correspondante a l'entier
        * @param elementNumber Numero de l'element demande
        * @return Chaine de caractere correspondante
        */
        string findStringOfElement(long elementNumber);

        /**
        * Recuperation de l'entier correspondant a une chaine
        * @param elementName Chaine recherchee
        * @return Entier correspondant
        */
        long findIntegerOfElement(string elementName);
};

/**
* class JeveuxBidirectionalMap
*   Enveloppe d'un pointeur intelligent vers un JeveuxBidirectionalMapInstance
* @author Nicolas Sellenet
*/
class JeveuxBidirectionalMap
{
    public:
        typedef boost::shared_ptr< JeveuxBidirectionalMapInstance > JeveuxBidirectionalMapPtr;

    private:
        JeveuxBidirectionalMapPtr _jeveuxBidirectionalMapPtr;

    public:
        JeveuxBidirectionalMap(string nom):
            _jeveuxBidirectionalMapPtr( new JeveuxBidirectionalMapInstance (nom) )
        {};

        ~JeveuxBidirectionalMap()
        {};

        JeveuxBidirectionalMap& operator=(const JeveuxBidirectionalMap& tmp)
        {
            _jeveuxBidirectionalMapPtr = tmp._jeveuxBidirectionalMapPtr;
            return *this;
        };

        const JeveuxBidirectionalMapPtr& operator->(void) const
        {
            return _jeveuxBidirectionalMapPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxBidirectionalMapPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* JEVEUXBIDIRECTIONALMAP_H_ */
