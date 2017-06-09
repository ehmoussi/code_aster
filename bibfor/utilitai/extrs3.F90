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

subroutine extrs3(resu, param, iordr, cel, itype,&
                  type, iad)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/lxliis.h"
#include "asterfort/utmess.h"
!
    integer :: itype, iad, iordr
    character(len=1) :: cel
    character(len=*) :: resu, param, type
!
! IN  : RESU   : NOM DE LA STRUCTURE "RESULTAT".
! IN  : NOPARA : NOM SYMBOLIQUE DU PARAMETRE.
! IN  : IORDR  : NUMERO DE RANGEMENT
! IN  : CEL    : CONDITION D'ACCES AUX PARAMETRES :
!                    'L' : LECTURE, 'E' : ECRITURE.
! in  : itype  : code indiquant que l'on desire le type
!                     = 0  pas de type
!                    /= 0  on fournit le type
! OUT : TYPE   : CODE DU TYPE
!               R REAL,I INTEGER,C COMPLEXE,K8 K16 K24 K32 K80 CHARACTER
! OUT : IAD    : ADRESSE JEVEUX DANS ZI,ZR,...
!     ------------------------------------------------------------------
!
    integer :: ipara, iatava, ire1, ire2, idebu, imaxi, iloty
    integer :: iaobj, len
    character(len=8) :: k8b, nomobj, k8debu, k8maxi
    character(len=24) :: valk(3)
    character(len=16) :: nopara
    character(len=19) :: nomsd
!     ------------------------------------------------------------------
!
    nomsd = resu
    nopara = param
!
    call jenonu(jexnom(nomsd//'.NOVA', nopara), ipara)
    if (ipara .eq. 0) then
        valk (1) = nopara
        valk (2) = nomsd
        call utmess('F', 'UTILITAI6_12', nk=2, valk=valk)
    endif
!
    call jeveuo(jexnum(nomsd//'.TAVA', ipara), 'L', iatava)
    nomobj = zk8(iatava-1+1)
    k8debu = zk8(iatava-1+2)
    call lxliis(k8debu, idebu, ire1)
    k8maxi = zk8(iatava-1+3)
    call lxliis(k8maxi, imaxi, ire2)
    if (abs(ire1)+abs(ire2) .gt. 0) then
        valk (1) = nopara
        valk (2) = k8debu
        valk (3) = k8maxi
        call utmess('F', 'UTILITAI6_13', nk=3, valk=valk)
    endif
!
    call jeveuo(nomsd//nomobj, cel, iaobj)
    iad = iaobj - 1 + (iordr-1)*imaxi + idebu
!
    if (itype .ne. 0) then
        call jelira(nomsd//nomobj, 'TYPE', cval=type)
        if (type(1:1) .eq. 'K') then
            ASSERT(len(type).ge.2)
            call jelira(nomsd//nomobj, 'LTYP', iloty)
            call codent(iloty, 'G', k8b)
            type = type(1:1)//k8b
        endif
    endif
!
end subroutine
