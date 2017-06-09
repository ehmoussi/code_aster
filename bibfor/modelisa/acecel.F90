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

subroutine acecel(noma, nomo, nbocc, ele_sup_num, ele_sup_typ, nb_ty_el, zjdlm, ier)
!
!
! --------------------------------------------------------------------------------------------------
!
!     AFFE_CARA_ELEM
!     COMPTEUR D'ELEMENTS
!
! --------------------------------------------------------------------------------------------------
!
! IN  : NOMA   : NOM DU MAILLAGE
! IN  : NOMO   : NOM DU MODELE
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
    use cara_elem_parameter_module
    implicit none
    character(len=8) :: noma, nomo
    integer :: nbocc(*), ele_sup_num(*), ele_sup_typ(*), nb_ty_el(*), zjdlm(*), ier
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
    integer :: ii, ifm, ixma, tt, jdme, nbmail, nummai, nutyel
!
    character(len=24) :: mlgnma, modmai
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    modmai = nomo//'.MAILLE'
    mlgnma = noma//'.NOMMAI'
    call jeexin(modmai, ixma)
    call jelira(mlgnma, 'NOMMAX', nbmail)
    ASSERT( ixma .ne. 0 )
    call jeveuo(modmai, 'L', jdme)
!
    ifm = iunifi('MESSAGE')
!
    nb_ty_el(1:ACE_NB_ELEMENT) = 0
!
    do nummai = 1, nbmail
        nutyel = zi(jdme+nummai-1)
        zjdlm(nummai) = nutyel
!
        do ii = 1 , ACE_NB_TYPE_ELEM
            if ( nutyel .eq. ele_sup_num(ii) ) then
                tt = ele_sup_typ(ii)
                nb_ty_el(tt) = nb_ty_el(tt) + 1
                exit
            endif
        enddo
    enddo
!
    write(ifm,100) nomo
    do ii=1 ,ACE_NB_ELEMENT
        if ( nb_ty_el(ii) .gt. 0 ) then
            write(ifm,110) nb_ty_el(ii),ACE_NM_ELEMENT(ii)
        endif
    enddo
100 format(/,5x,'LE MODELE ',a8,' CONTIENT : ')
110 format(35x,i6,' ELEMENT(S) ',A16)
!
!   Vérification de la cohérence des affectations
    if (nbocc(ACE_POUTRE).ne.0 .and. nb_ty_el(ACE_NU_POUTRE).eq.0) then
        call utmess('E', 'MODELISA_29', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_COQUE).ne.0 .and. nb_ty_el(ACE_NU_COQUE).eq.0) then
        call utmess('E', 'MODELISA_30', sk=nomo)
        ier = ier + 1
    endif
    if ((nbocc(ACE_DISCRET)+nbocc(ACE_DISCRET_2D)).ne.0 .and. &
         nb_ty_el(ACE_NU_DISCRET).eq.0) then
        call utmess('E', 'MODELISA_31', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_ORIENTATION).ne.0 .and. (nb_ty_el(ACE_NU_POUTRE) + &
        nb_ty_el(ACE_NU_DISCRET)+nb_ty_el(ACE_NU_BARRE)).eq.0) then
        call utmess('E', 'MODELISA_32', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_CABLE).ne.0 .and. nb_ty_el(ACE_NU_CABLE).eq.0) then
        call utmess('E', 'MODELISA_33', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_BARRE).ne.0 .and. nb_ty_el(ACE_NU_BARRE).eq.0) then
        call utmess('E', 'MODELISA_34', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_MASSIF).ne.0 .and. (nb_ty_el(ACE_NU_MASSIF)+nb_ty_el(ACE_NU_THHMM)).eq.0) then
        call utmess('E', 'MODELISA_35', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_GRILLE).ne.0 .and. nb_ty_el(ACE_NU_GRILLE).eq.0) then
        call utmess('E', 'MODELISA_36', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_MEMBRANE).ne.0 .and. nb_ty_el(ACE_NU_MEMBRANE).eq.0) then
        call utmess('E', 'MODELISA_55', sk=nomo)
        ier = ier + 1
    endif
    if (nbocc(ACE_MASS_REP).ne.0 .and. nb_ty_el(ACE_NU_DISCRET).eq.0 ) then
        call utmess('E', 'MODELISA_31', sk=nomo)
        ier = ier + 1
    endif
!
    call jedema()
end subroutine
