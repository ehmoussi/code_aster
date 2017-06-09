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

subroutine tecael(iadzi, iazk24, noms)

use calcul_module, only : ca_ialiel_, ca_iamaco_, ca_iamsco_, ca_icaeli_,&
     ca_icaelk_, ca_iel_, ca_igr_, ca_illiel_,&
     ca_ilmaco_, ca_ilmsco_, ca_nomte_, ca_nomtm_, ca_option_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/assert.h"

    integer, intent(out) :: iadzi
    integer, intent(out) :: iazk24
    integer, intent(in), optional :: noms
!----------------------------------------------------------------------
! Entree:
!     noms=1/0
!        /1  (defaut) : On remplit v(3),...,v(3+nbno)
!        /0           : On ne remplit pas v(3),...,v(3+nbno) : noms de la maille et de ses noeuds
!                       => C'est moins couteux en CPU.
!
! Sorties:
!     iadzi est l'adresse d'un vecteur d'entiers  contenant :
!     dim(v)=4+nbno
!        v(1) : numero de la maille
!        v(2) : nombre de noeuds de la maille (nbno)
!        v(2+   1) : numero du 1er noeud de la maille
!        ...
!        v(2+nbno) : numero du der noeud de la maille
!        v(2+nbno +1) : numero du grel
!        v(2+nbno +2) : numero de l'element dans le grel
!
!     iazk24 est l'adresse d'un vecteur de k24 contenant :
!     dim(v)=8+nbno
!        v(1) : nom du maillage       (k8)
!        v(2) : nom du ligrel         (k19)
!        v(3) : nom de la maille      (k8)
!        v(3  +1) : nom du 1er noeud de la maille (k8)
!        ...
!        v(3+nbno) : nom du der noeud de la maille (k8)
!        v(3+nbno+1): type_element(k16)
!        v(3+nbno+2): ca_option_ que l'on calcule (k16)
!        v(3+nbno+3): type_maille associe au type_element(k8)
!
!   Remarques :
!     si la maille est tardive son nom est conventionellement : ' '
!     si un noeud est tardif   son nom est conventionellement : ' '
!----------------------------------------------------------------------

    integer ::  ima, ino, nno, nuno, noms2

    character(len=8) :: ma, nomma, nomno
!----------------------------------------------------------------------

    if (present(noms)) then
        noms2=noms
    else
        noms2=1
    endif
    ASSERT(noms2.eq.0 .or. noms2.eq.1)


!   -- recuperation du numero de la maille et du nombre de noeuds :
!   ---------------------------------------------------------------
    ma = zk24(ca_icaelk_-1+1)(1:8)

    ima = zi(ca_ialiel_-1+zi(ca_illiel_+ca_igr_-1)+ca_iel_-1)
    if (ima .gt. 0) then
        nno = zi(ca_ilmaco_-1+ima+1) - zi(ca_ilmaco_-1+ima)
        zi(ca_icaeli_-1+1) = ima
        zi(ca_icaeli_-1+2) = nno
        if (noms2.eq.1) then
            call jenuno(jexnum(ma//'.NOMMAI', ima), nomma)
            zk24(ca_icaelk_-1+3) = nomma
        else
            zk24(ca_icaelk_-1+3) = ' '
        endif
    else
        nno = zi(ca_ilmsco_-1-ima+1) - zi(ca_ilmsco_-1-ima) - 1
        zi(ca_icaeli_-1+1) = ima
        zi(ca_icaeli_-1+2) = nno
        zk24(ca_icaelk_-1+3) = ' '
    endif

    zk24(ca_icaelk_-1+3+nno+1) = ca_nomte_
    zk24(ca_icaelk_-1+3+nno+2) = ca_option_
    zk24(ca_icaelk_-1+3+nno+3) = ca_nomtm_


!   -- recuperation des numeros globaux des noeuds :
!   -------------------------------------------------
    do 10,ino = 1,nno
    if (ima .gt. 0) then
        nuno = zi(ca_iamaco_-1+zi(ca_ilmaco_+ima-1)+ino-1)
    else
        nuno = zi(ca_iamsco_-1+zi(ca_ilmsco_-ima-1)+ino-1)
    endif
    zi(ca_icaeli_-1+2+ino) = nuno

    if ((noms2.eq.1) .and. (nuno .gt. 0)) then
        call jenuno(jexnum(ma//'.NOMNOE', nuno), nomno)
        zk24(ca_icaelk_-1+3+ino) = nomno
    else
        zk24(ca_icaelk_-1+3+ino) = ' '
    endif
    10 end do

    zi(ca_icaeli_-1+2+nno+1) = ca_igr_
    zi(ca_icaeli_-1+2+nno+2) = ca_iel_

    iadzi = ca_icaeli_
    iazk24 = ca_icaelk_


end subroutine
