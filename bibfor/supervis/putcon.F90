! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine putcon(nomres, nbind, ind, valr, vali,&
                  num, ier)
! aslint: disable=
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jjvern.h"
    character(len=*) :: nomres
    integer :: ier, nbind, ind(nbind), num
    real(kind=8) :: valr(nbind), vali(nbind)
! IN  NOMRES  K*  NOM DE L'OBJET OU COLLECTION JEVEUX
! IN  NBIND   I   TAILLE DU VECTEUR D'INDICE
! IN  IND     I   LISTE D INDICE DES VALEURS MODIFIEES DANS LE VECTEUR
! IN  VALR    R   VECTEUR REEL A AFFECTER
! IN  VALI    C   VECTEUR IMAGINAIRE A AFFECTER
! IN  NUM    I    NUMERO D'ORDRE SI COLLECTION
! OUT IER     I   <0=ERREUR 1=OK
!
    character(len=4) :: type
    character(len=1) :: xous, genr
    integer :: jres, iret, i, nbindj
    character(len=32) :: noml32
!     ------------------------------------------------------------------
    call jemarq()
    noml32=nomres
!
    call jjvern(noml32, 0, iret)
    call jelira(noml32, 'XOUS', cval=xous)
    call jelira(noml32, 'GENR', cval=genr)
    if (iret .eq. 0) then
!     CET OBJET N'EXISTE PAS
        ier=0
    else if ((xous.eq.'S').and.(genr.ne.'N')) then
!     ------------------------------------------------------------------
!     CET OBJET EXISTE ET EST SIMPLE. ON PEUT AVOIR SA VALEUR
!     ------------------------------------------------------------------
        call jeveuo(noml32, 'E', jres)
        call jelira(noml32, 'TYPELONG', cval=type)
        call jelira(noml32, 'LONMAX', nbindj)
        if (nbind .gt. nbindj) then
            ier=0
        endif
        if (type .eq. 'R') then
!     LES VALEURS SONT REELLES
            ier=1
            do 66 i = 1, nbind
                zr(jres+ind(i)-1)=valr(i)
66          continue
        else if (type.eq.'C') then
!     LES VALEURS SONT COMPLEXES
            ier=1
            do 67 i = 1, nbind
                zc(jres+ind(i)-1)=dcmplx(valr(i),vali(i))
67          continue
        else
!     LES VALEURS SONT NI REELLES NI COMPLEXES
            ier=0
        endif
    else if (xous.eq.'X') then
!     ------------------------------------------------------------------
!     CET OBJET EST UNE COLLECTION, ON PEUT AVOIR SA VALEUR GRACE A NUM
!     LE NUMERO D'ORDRE DANS LA COLLECTION
!     ------------------------------------------------------------------
        call jeveuo(jexnum(noml32, num), 'E', jres)
        call jelira(noml32, 'TYPELONG', cval=type)
        call jelira(jexnum(noml32, num), 'LONMAX', nbindj)
        if (nbind .gt. nbindj) then
            ier=0
        endif
        if (type .eq. 'R') then
!     LES VALEURS SONT REELLES
            ier=1
            do 68 i = 1, nbind
                zr(jres+ind(i)-1)=valr(i)
68          continue
        else if (type.eq.'C') then
!     LES VALEURS SONT COMPLEXES
            ier=1
            do 69 i = 1, nbind
                zc(jres+ind(i)-1)=dcmplx(valr(i),vali(i))
69          continue
        else
!     LES VALEURS SONT NI REELLES NI COMPLEXES
            ier=0
        endif
!         IER=0
    else if ((xous.eq.'S').and.(genr.eq.'N')) then
!     ------------------------------------------------------------------
!     CET OBJET EST SIMPLE MAIS C EST UN REPERTOIRE DE NOMS
!     ------------------------------------------------------------------
        ier=0
    endif
!
    call jedema()
end subroutine
