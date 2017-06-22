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

subroutine cragch(long, typcoe, typval, ligrch)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/agcart.h"
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeagco.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    integer, intent(in) :: long
    character(len=4), intent(in) :: typcoe
    character(len=4), intent(in) :: typval
    character(len=19), intent(in) :: ligrch
!
! ---------------------------------------------------------------------
!     CREATION OU EXTENSION DES CARTES .CMULT ET .CIMPO
!     DU LIGREL DE CHARGE LIGRCH D'UN NOMBRE DE TERMES
!     EGAL A LONG
!
!     LONG DOIT ETRE > 0
!
!----------------------------------------------------------------------
!  LONG          - IN   - I    - : NOMBRE DE GRELS A RAJOUTER A LIGRCH-
!----------------------------------------------------------------------
!  TYPCOE        - IN   - K4   - : TYPE DES COEFFICIENTS A ECRIRE DANS-
!                -      -      - :  LA CARTE CMULT := 'REEL' OU 'COMP'-
!----------------------------------------------------------------------
!  TYPVAL        - IN   - K4   - : TYPE DES VALEURS A ECRIRE DANS L
!                -      -      - :  CARTE CIMPO :='REEL' OU 'COMP'
!                -      -      - :                 OU 'FONC'
!----------------------------------------------------------------------
!  LIGRCH        - IN   - K24  - : NOM DU LIGREL DE CHARGE
!                - JXVAR-      -
!----------------------------------------------------------------------
!
!
! --------- VARIABLES LOCALES ------------------------------------------
    character(len=8) :: noma, mod, base
    character(len=19) :: ca1, ca2
    integer :: iret, longut,   ngdmx, nedit, ndisp
    integer, pointer :: desc(:) => null()
    character(len=8), pointer :: lgrf(:) => null()
! --------- FIN  DECLARATIONS  VARIABLES LOCALES ----------------------
!
    call jemarq()
    ASSERT(long.gt.0)
!
! --- CARTES DE LA CHARGE ---
!
    if (ligrch(12:13) .eq. 'TH') then
        ca1= ligrch(1:8)//'.CHTH.CMULT'
        ca2= ligrch(1:8)//'.CHTH.CIMPO'
    else if (ligrch(12:13).eq.'ME') then
        ca1= ligrch(1:8)//'.CHME.CMULT'
        ca2= ligrch(1:8)//'.CHME.CIMPO'
    else if (ligrch(12:13).eq.'AC') then
        ca1= ligrch(1:8)//'.CHAC.CMULT'
        ca2= ligrch(1:8)//'.CHAC.CIMPO'
    else
        ASSERT(.false.)
    endif
!
! --- ON CREE LES CARTES .CMULT ET .CIMPO SI ELLES N'EXISTENT PAS ---
!
    call jeexin(ca1//'.DESC', iret)
    if (iret .eq. 0) then
!
! --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
!
        call dismoi('NOM_MODELE', ligrch(1:8), 'CHARGE', repk=mod)
!
! --- MAILLAGE ASSOCIE AU MODELE ---
!
        call jeveuo(mod(1:8)//'.MODELE    '//'.LGRF', 'L', vk8=lgrf)
        noma = lgrf(1)
!
        if (typcoe .eq. 'REEL' .or. typcoe .eq. 'FONC') then
            call alcart('G', ca1, noma, 'DDLM_R')
        else if (typcoe.eq.'COMP') then
            call alcart('G', ca1, noma, 'DDLM_C')
        else
            ASSERT(.false.)
        endif
!
        if (typval .eq. 'REEL') then
            call alcart('G', ca2, noma, 'DDLI_R')
        else if (typval.eq.'FONC') then
            call alcart('G', ca2, noma, 'DDLI_F')
        else if (typval.eq.'COMP') then
            call alcart('G', ca2, noma, 'DDLI_C')
        else
            ASSERT(.false.)
        endif
    endif
!
!
!
! --- VERIFICATION DE L'ADEQUATION DE LA TAILLE DES CARTES ---
! --- .CMULT ET .CIMPO DE LA CHARGE                        ---
!
    call jeveuo(ca1(1:19)//'.DESC', 'L', vi=desc)
    ngdmx = desc(2)
    nedit = desc(3)
    ndisp = ngdmx - nedit
    ASSERT(ndisp.ge.0)
    if (long .gt. ndisp) then
! ---       LA TAILLE DES CARTES .CMULT ET .CIMPO EST    ---
! ---       INSUFFISANTE ON LES REDIMENSIONNE DE MANIERE ---
! ---       ADEQUATE                                     ---
        longut = nedit + long
        call agcart(longut, ca1)
        call agcart(longut, ca2)
!
! ---     AGRANDISSEMENT DE CA1.LIMA :
        call jedupo(ca1//'.LIMA', 'V', ca1//'.TRAV', .false._1)
        call jelira(ca1//'.LIMA', 'CLAS', cval=base)
        call jedetr(ca1//'.LIMA')
        call jeagco(ca1//'.TRAV', ca1//'.LIMA', longut, 2*longut, base)
        call jedetr(ca1//'.TRAV')
!
! ---     AGRANDISSEMENT DE CA2.LIMA :
        call jedupo(ca2//'.LIMA', 'V', ca2//'.TRAV', .false._1)
        call jelira(ca2//'.LIMA', 'CLAS', cval=base)
        call jedetr(ca2//'.LIMA')
        call jeagco(ca2//'.TRAV', ca2//'.LIMA', longut, 2*longut, base)
        call jedetr(ca2//'.TRAV')
    endif
!
    call jedema()
end subroutine
