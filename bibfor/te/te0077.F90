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

subroutine te0077(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/connec.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          OPTION : 'MASS_THER'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!
    integer :: icodre(1)
    character(len=16) :: phenom
    character(len=8) :: elrefe, alias8
    real(kind=8) :: dfdx(9), dfdy(9), poids, r, cp(1)
    real(kind=8) :: mt(9, 9), coorse(18)
    integer :: ndim, nno, nnos, kp, npg, i, j, k, ij, itemps, imattt
    integer :: c(6, 9), ise, nse, nnop2, npg2, ipoid2, ivf2, idfde2
    integer :: ipoids, ivf, idfde, igeom, imate, jgano, ibid
!
!-----------------------------------------------------------------------
    real(kind=8) :: deltat
!-----------------------------------------------------------------------
    call elref1(elrefe)
!
    if (lteatt('LUMPE','OUI')) then
        call teattr('S', 'ALIAS8', alias8, ibid)
        if (alias8(6:8) .eq. 'QU9') elrefe='QU4'
        if (alias8(6:8) .eq. 'TR6') elrefe='TR3'
    endif
!
    call elrefe_info(elrefe=elrefe,fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg2,jpoids=ipoid2,jvf=ivf2,jdfde=idfde2,jgano=jgano)
    call elrefe_info(elrefe=elrefe,fami='MASS',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PMATTTR', 'E', imattt)
    deltat = zr(itemps+1)
!
    call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
    if (phenom .eq. 'THER') then
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', phenom, 1, 'INST', [zr(itemps)],&
                    1, 'RHO_CP', cp, icodre(1), 1)
    else if (phenom .eq. 'THER_ORTH') then
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', phenom, 1, 'INST', [zr(itemps)],&
                    1, 'RHO_CP', cp, icodre(1), 1)
    else
        call utmess('F', 'ELEMENTS2_63')
    endif
!
!
    if (.not.lteatt('LUMPE','OUI')) then
!
        do 101 kp = 1, npg
            k=(kp-1)*nno
            call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy)
            if (lteatt('AXIS','OUI')) then
                r = 0.d0
                do 102 i = 1, nno
                    r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
102              continue
                poids = poids*r
            endif
            ij = imattt - 1
            do 103 i = 1, nno
!
                do 103 j = 1, i
                    ij = ij + 1
                    zr(ij) = zr(ij) + poids * cp(1)/deltat * zr(ivf+k+i- 1) * zr(ivf+k+j-1)
103              continue
101      continue
!
    else
!
        call connec(nomte, nse, nnop2, c)
!
        do 10 i = 1, nnop2
            do 10 j = 1, nnop2
                mt(i,j)=0.d0
10          continue
!
! BOUCLE SUR LES SOUS-ELEMENTS
!
        do 200 ise = 1, nse
!
            do 205 i = 1, nno
                do 205 j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
205              continue
!
            do 201 kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                if (lteatt('AXIS','OUI')) then
                    r = 0.d0
                    do 202 i = 1, nno
                        r = r + coorse(2*(i-1)+1)*zr(ivf2+k+i-1)
202                  continue
!
                    poids = poids*r
                    if (r .eq. 0.d0) then
                        call utmess('F', 'ELEMENTS3_10')
                    endif
                endif
!
                do 203 i = 1, nno
                    do 203 j = 1, nno
                        mt(c(ise,i),c(ise,j)) = mt(&
                                                c(ise, i),&
                                                c(ise, j)) + poids * cp(1)/deltat * zr(ivf2+k+i-1&
                                                &) * zr(ivf2+k+j-1&
                                                )
203                  continue
201          continue
!
200      continue
!
        ij = imattt-1
        do 206 i = 1, nnop2
            do 206 j = 1, i
                ij = ij +1
                zr(ij)=mt(i,j)
206          continue
!
    endif
end subroutine
