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

subroutine vtcrem(chamno, matass, base, typc)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/vtcrea.h"
    character(len=*) :: chamno, matass, base, typc
!     CREATION D'UN CHAM_NO S'APPUYANT SUR LA NUMEROTATION DE MATASS
!     ------------------------------------------------------------------
!     OUT CHAMNO : K19 : NOM DU CHAM_NO CONCERNE
!     IN  MATASS : K19 : NOM DE LA MATRICE
!     IN  BASE   : K1 : BASE JEVEUX ('G', 'V' , ... )
!     IN  TYPC   : K1 : TYPE JEVEUX DE BASE
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
    character(len=24) :: refa, crefe(2)
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: jrefa, neq
!-----------------------------------------------------------------------
    data refa/'                   .REFA'/
!     ------------------------------------------------------------------
    call jemarq()
!
    refa(1:19) = matass
    call jeveuo(refa, 'L', jrefa)
    call dismoi('NB_EQUA', matass, 'MATR_ASSE', repi=neq)
    crefe(1)=zk24(jrefa-1+1)
    crefe(2)=zk24(jrefa-1+2)(1:14)//'.NUME'
    call vtcrea(chamno, crefe, base, typc, neq)
!
    call jedema()
end subroutine
