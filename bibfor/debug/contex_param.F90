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

subroutine contex_param(nomop, nompar)
    implicit none
!
! person_in_charge: jacques.pellet at edf.fr
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: nomop, nompar
!     -----------------------------------------------------------------
!     BUT:
!     ---
!     IMPRIMER DANS LE FICHIER 'MESSAGE' DES INFORMATIONS CONCERNANT
!     LE CONTEXTE D'UNE ERREUR survenue dans un calcul elementaire  :
!     ON PEUT DONNER :
!      - LE NOM D'UNE OPTION (NOMOP)
!      - LE NOM D'UN PARAMETRE DE L'OPTION (NOMPAR)
!
!
!     ENTREES:
!     --------
! NOMOP   : NOM D'UNE OPTION DE CALCUL ELEMENTAIRE  (OU ' ')
! NOMPAR  : NOM D'UN PARAMETRE D'OPTION DE CALCUL ELEMENTAIRE (OU ' ')
!
!
    character(len=8) :: nompa2, nomail, nomgd
    integer :: jdesop, iapara, nbin, nbou, iadzi, iazk24
    integer :: nblig, indic, k, itrou, iopt, igd, jdsgd
    aster_logical :: lopt, lpara, lgd
    character(len=80), pointer :: comlibr(:) => null()
!
!
    call tecael(iadzi, iazk24)
    nomail=zk24(iazk24-1+3)(1:8)
!
    call utmess('I', 'ELEMENT_15', sk=nomail)
!
    call jeveuo('&CATA.CL.COMLIBR', 'L', vk80=comlibr)
!
    nompa2=nompar
    igd=0
!
!
!   1) CONTEXTE DE l'OPTION :
!   -------------------------
!     CALCUL DE LOPT ET IOPT :
    if (nomop .ne. ' ') then
        call jenonu(jexnom('&CATA.OP.NOMOPT', nomop), iopt)
    else
        iopt=0
    endif
    lopt=(iopt.ne.0)
!
    if (lopt) then
        call utmess('I', 'ELEMENT_16', sk=nomop)
        call jeveuo(jexnum('&CATA.OP.DESCOPT', iopt), 'L', jdesop)
        call jeveuo(jexnum('&CATA.OP.OPTPARA', iopt), 'L', iapara)
!
        nbin=zi(jdesop-1+2)
        nbou=zi(jdesop-1+3)
        nblig=zi(jdesop-1+4+nbin+nbou+1)
        indic=zi(jdesop-1+4+nbin+nbou+2)
        if (nblig .gt. 0) then
            do 10 k = indic, indic-1+nblig
                call utmess('I', 'ELEMENT_17', sk=comlibr(k))
 10         continue
        endif
    endif
!
!
!
!   2) CONTEXTE DU PARAMETRE :
!   --------------------------
!     CALCUL DE LPARA :
    lpara=lopt .and. (nompa2.ne.' ')
!
    if (lpara) then
        itrou=indik8(zk8(iapara-1+1),nompa2,1,nbin)
        if (itrou .gt. 0) then
            call utmess('I', 'ELEMENT_18', sk=nompa2)
            nblig=zi(jdesop-1+6+nbin+nbou+2*(itrou-1)+1)
            indic=zi(jdesop-1+6+nbin+nbou+2*(itrou-1)+2)
            igd=zi(jdesop-1+4+itrou)
        else
            itrou=indik8(zk8(iapara-1+nbin+1),nompa2,1,nbou)
            ASSERT(itrou.gt.0)
            call utmess('I', 'ELEMENT_19', sk=nompa2)
            nblig=zi(jdesop-1+6+3*nbin+nbou+2*(itrou-1)+1)
            indic=zi(jdesop-1+6+3*nbin+nbou+2*(itrou-1)+2)
            igd=zi(jdesop-1+4+nbin+itrou)
        endif
        if (nblig .gt. 0) then
            do 20 k = indic, indic-1+nblig
                call utmess('I', 'ELEMENT_17', sk=comlibr(k))
 20         continue
        endif
    endif
!
!
!
!   3) CONTEXTE DE LA GRANDEUR :
!   ----------------------------
    lgd=(igd.ne.0)
    if (lgd) then
        call jenuno(jexnum('&CATA.GD.NOMGD', igd), nomgd)
!       -- ON N'IMPRIME RIEN POUR ADRSJEVE !
        if (nomgd .ne. 'ADRSJEVE') then
            call utmess('I', 'ELEMENT_22', sk=nomgd)
            call jeveuo(jexnum('&CATA.GD.DESCRIGD', igd), 'L', jdsgd)
            nblig=zi(jdsgd-1+6)
            indic=zi(jdsgd-1+7)
            if (nblig .gt. 0) then
                do 30 k = indic, indic-1+nblig
                    call utmess('I', 'ELEMENT_17', sk=comlibr(k))
 30             continue
            endif
        endif
!
    endif
!
    ASSERT(.false.)
!
end subroutine
