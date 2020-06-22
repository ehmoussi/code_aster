! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine sigmca(tablca, icabl, nbnoca, numaca,&
                  quad, sigmcabl, prem)
    implicit none
!  DESCRIPTION : MISE A JOUR DE LA CARTE ELEMENTAIRE DES CONTRAINTES
!  -----------   INITIALES POUR LE CABLE COURANT
!                APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
!
!  IN     : TABLCA : CHARACTER*19
!                    NOM DE LA TABLE DECRIVANT LES CABLES
!  IN     : ICABL  : INTEGER , SCALAIRE
!                    NUMERO DU CABLE
!  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
!                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
!  IN     : NUMACA : CHARACTER*19 , SCALAIRE
!                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
!                    NUMEROS DES MAILLES APPARTENANT AUX CABLES
!  IN     : QUAD   : VRAI SI MAILLAGE QUADRATIQUE (SEG3)
!
!  IN     : SIGMCABL : NOM DE LA STRUCTURE PERMETTANT DE STOCKER LES VALEURS
!                      DE LA CONTRAINTE
!  IN     : PREM   : INTEGER INDICE DE LA PREMIERE PLACE LIBRE DANS LE VECTEUR 
!                    NUMA 
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
!
! ARGUMENTS
! ---------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
    aster_logical :: quad
    character(len=19) :: numaca, tablca, sigmcabl
    integer :: icabl, nbnoca(*), prem
!
! VARIABLES LOCALES
! -----------------
    integer :: idecma, idecno, imail, ipara, jnumac, jtens, nblign, nbmaca
    integer :: nbno, nbpara, numail, nbma, mma
    integer :: iinuma, iivale, nbcmp, lonuti
    character(len=24) :: tens, parcr
    real(kind=8) :: rtens
    aster_logical :: trouve
    real(kind=8), pointer :: sigmvale(:) => null()
    integer, pointer :: tbnp(:) => null(), sigmnuma(:) => null()
    character(len=24), pointer :: tblp(:) => null()
    data          parcr /'TENSION                 '/
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    call jemarq()
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 1   ACCES AUX DONNEES ET AUX RESULTATS DE CALCUL UTILES
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
    nbno = nbnoca(icabl)
!
! 1.1 RECUPERATION DE LA TENSION LE LONG DES CABLES
! ---
    call jeveuo(tablca//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    call jeveuo(tablca//'.TBLP', 'L', vk24=tblp)
    trouve = .false.
    do ipara = 1, nbpara
        if (tblp(1+4*(ipara-1)) .eq. parcr) then
            trouve = .true.
            tens = tblp(1+4*(ipara-1)+2)
            call jeveuo(tens, 'L', jtens)
        endif
        if (trouve) goto 11
    end do
 11 continue
    idecno = nblign - nbno
!
! 1.2 NUMEROS DES MAILLES APPARTENANT AUX CABLES
! ---
    call jelira(numaca, 'LONUTI', nbmaca)
    call jeveuo(numaca, 'L', jnumac)
    if (quad) then
        ASSERT((mod(nbno-1, 2).eq.0))
        nbma=(nbno-1)/2
        mma = 2
    else
        nbma = nbno-1
        mma = 1
    endif
    idecma = nbmaca - nbma
!
! 1.3 STOCKAGE DU RESULTAT 
! ---
   call jeveuo( sigmcabl//'.NUMA', 'E', vi=sigmnuma )
   call jeveuo( sigmcabl//'.VALE', 'E', vr=sigmvale )
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 2   MISE A JOUR DES CONTRAINTES INITIALES AUX ELEMENTS
!     DES CABLES
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
!.... BOUCLE SUR LE NOMBRE DE MAILLES DU CABLE COURANT
!
!   Nombre de composantes à stocker par maille
    call jelira(sigmcabl//'.NCMP', 'LONUTI', lonuti)
    nbcmp=lonuti
    ASSERT(nbcmp==3)
!   Position du premier numéro de maille pour le câble courant
    iinuma=prem
!   On enregistre nbcmp valeurs par maille
!   Position de la première valeur pour le câble courant
    iivale=(prem-1)*nbcmp+1
    do imail = 1, nbma
        numail = zi(jnumac+idecma+imail-1)
        rtens = ( zr(jtens+idecno+mma*imail-mma) + zr(jtens+idecno+ mma*imail) ) / 2.0d0
        sigmnuma(iinuma) = numail
        sigmvale(iivale-1+1)=rtens
        sigmvale(iivale-1+2)=0.d0
        sigmvale(iivale-1+3)=0.d0
        iinuma = iinuma + 1
        iivale = iivale + nbcmp 
    end do
    prem=iinuma
!
    call jedema()
!
! --- FIN DE SIGMCA.
end subroutine
