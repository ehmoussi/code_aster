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

subroutine ut2pgl(nn, nc, p, sg, sl)
!
    implicit none
#include "asterfort/lcdi2m.h"
#include "asterfort/lcps2m.h"
#include "asterfort/lcso2m.h"
#include "asterfort/lctr2m.h"
#include "asterfort/mapvec.h"
#include "asterfort/mavec.h"
#include "asterfort/upletr.h"
#include "asterfort/uplstr.h"
#include "asterfort/ut2agl.h"
#include "asterfort/ut2mgl.h"
#include "asterfort/vecmap.h"
    real(kind=8) :: p(3, 3), sl(*), sg(*)
    integer :: nn, nc, n, n1, nddl
    real(kind=8) :: matsy1(12, 12), matsy2(12, 12)
    real(kind=8) :: matas2(12, 12), matsym(12, 12)
    real(kind=8) :: matasy(12, 12)
    real(kind=8) :: parsym(78), parasy(78)
    real(kind=8) :: parsmg(12, 12), parayg(12, 12)
    real(kind=8) :: matril(12, 12), matrig(12, 12)
    real(kind=8) :: vecsym(78), vecasy(78)
!     ------------------------------------------------------------------
!     PASSAGE D'UNE MATRICE TRIANGULAIRE ANTISYMETRIQUE DE NN*NC LIGNES
!     DU REPERE LOCAL AU REPERE GLOBAL (3D)
!     ------------------------------------------------------------------
!IN   I   NN   NOMBRE DE NOEUDS
!IN   I   N    NOMBRE DE NOEUDS
!IN   I   NC   NOMBRE DE COMPOSANTES
!IN   R   P    MATRICE DE PASSAGE 3D DE GLOBAL A LOCAL
!IN   R   SL   NN*NC COMPOSANTES DE LA TRIANGULAIRE SL DANS LOCAL
!OUT  R   SG   NN*NC COMPOSANTES DE LA TRIANGULAIRE SG DANS GLOBAL
!     ------------------------------------------------------------------
!
    nddl = nn * nc
    n = nddl*nddl
    n1 = (nddl+1)*nddl/2
!
    call vecmap(sg, n, matril, nddl)
    call lctr2m(nddl, matril, matsy1)
    call lcso2m(nddl, matril, matsy1, matsy2)
    call lcdi2m(nddl, matril, matsy1, matas2)
    call lcps2m(nddl, 0.5d0, matsy2, matsym)
    call mavec(matsym, nddl, vecsym, n1)
    call lcps2m(nddl, 0.5d0, matas2, matasy)
    call mavec(matasy, nddl, vecasy, n1)
    call ut2mgl(nn, nc, p, vecsym, parsym)
    call uplstr(nddl, parsmg, parsym)
    call ut2agl(nn, nc, p, vecasy, parasy)
    call upletr(nddl, parayg, parasy)
    call lcso2m(nddl, parsmg, parayg, matrig)
    call mapvec(matrig, nddl, sl, n)
!
!
end subroutine
