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

subroutine rotama(geomi, pt, d, angl, bidim)
    implicit none
!
!     BUT : ROTATION D'AXE QUELCONQUE D'UN MAILLAGE
!
!     IN :
!            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE A TOURNER
!            NBNO   : NOMBRE DE NOEUDS DE GEOMI
!            PT     : POINT DE L'AXE DE ROTATION
!            D    : DECTION DE L'AXE DE ROTATION
!            ANGL   : ANGLE DE ROTATION
!            BIDIM  : BOOLEEN VRAI SI GEOMETRIE 2D
!     OUT:
!            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE ACTUALISE
!
!
! ----------------------------------------------------------------------
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/matfpe.h"
#include "asterc/r8dgrd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "blas/dnrm2.h"
    integer :: n1, i, iadcoo
    aster_logical :: bidim
    character(len=19) :: geomi
    character(len=24) :: coorjv
    real(kind=8) :: angl, pt(3), d(3), p1mx, p1my, p1mz, ca, sa, p1m, prec
! ----------------------------------------------------------------------
!
    call matfpe(-1)
!
    call jemarq()
    coorjv=geomi(1:19)//'.VALE'
    call jeveuo(coorjv, 'E', iadcoo)
    call jelira(coorjv, 'LONMAX', n1)
    prec=1.d-14
    n1=n1/3
    angl=angl*r8dgrd()
    ca=cos(angl)
    sa=sin(angl)
    iadcoo=iadcoo-1
!     -- ON TRAITE LE CAS 2D SEPAREMENT POUR OPTIMISER :
    if (bidim) then
        do 10 i = 1, n1
            p1mx=zr(iadcoo+3*(i-1)+1)-pt(1)
            p1my=zr(iadcoo+3*(i-1)+2)-pt(2)
            zr(iadcoo+3*(i-1)+1)=pt(1)+ca*p1mx-sa*p1my
            zr(iadcoo+3*(i-1)+2)=pt(2)+ca*p1my+sa*p1mx
 10     continue
    else
        if (dnrm2(3,d,1) .lt. prec) then
            call utmess('F', 'ALGORITH10_48')
        else
            p1m=dnrm2(3,d,1)
            d(1)=d(1)/p1m
            d(2)=d(2)/p1m
            d(3)=d(3)/p1m
            do 20 i = 1, n1
                p1mx=zr(iadcoo+3*(i-1)+1)-pt(1)
                p1my=zr(iadcoo+3*(i-1)+2)-pt(2)
                p1mz=zr(iadcoo+3*(i-1)+3)-pt(3)
                p1m=p1mx*d(1)+p1my*d(2)+p1mz*d(3)
                zr(iadcoo+3*(i-1)+1)=pt(1)+ ca*p1mx+(1-ca)*p1m*d(1)+&
                sa*(d(2)*p1mz-d(3)*p1my)
                zr(iadcoo+3*(i-1)+2)=pt(2)+ ca*p1my+(1-ca)*p1m*d(2)+&
                sa*(d(3)*p1mx-d(1)*p1mz)
                zr(iadcoo+3*(i-1)+3)=pt(3)+ ca*p1mz+(1-ca)*p1m*d(3)+&
                sa*(d(1)*p1my-d(2)*p1mx)
 20         continue
        endif
    endif
    call jedema()
    call matfpe(1)
!
end subroutine
