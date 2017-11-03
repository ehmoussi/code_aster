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

subroutine relax_acier_cable(fami, kpg, ksp, imate, sigm, epsm, deps, vim, option,&
                  materi, sigp, vip, dsde)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/relax_cable.h"
#include "asterfort/rk5adp.h"
#include "asterfort/utmess.h"
!
    character(len=*)  :: fami, materi
    integer           :: kpg, ksp, imate
    real(kind=8)      :: sigm, epsm, deps, vim(*)
    real(kind=8)      :: sigp, vip(*), dsde
    character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
!           RELAXATION POUR DES CÂBLES UTILISÉES DANS LES ÉTUDES BETON PRÉCONTRAINT
!
!           LOI DU TYPE LEMAITRE
!
! --------------------------------------------------------------------------------------------------
!
! IN
!   fami    : famille du point de gauss
!   kpg     : numéro du point de gauss
!   ksp     : numéro du sous-point de gauss
!   imate   : pointeur matériau
!   sigm    : contrainte  à t-
!   epsm    : déformation à t-
!   deps    : déformation(t+) - déformation(t-) - incrément déformation thermique
!   vim     : variable internes moins
!   option  : option de calcul
!   materi  : nom du matériau
!
! OUT
!   sigp    : contraintes plus
!   vip     : variable internes plus
!   dsde    : tangente au comportement dsig/deps
!
! --------------------------------------------------------------------------------------------------
!
    integer      :: jtp, jtm, icarcr, iret0, iret1
    real(kind=8) :: temper0, temper1

!   Pour la loi de comportement
    real(kind=8)       :: ldcpar(1)
    integer            :: ldcpai(1)
    character(len=8)   :: ldcpac(1)
    real(kind=8)       :: temps0, temps1, dtemps
!   Équations du système
    integer, parameter :: nbequa=4
    real(kind=8)       :: y0(nbequa), dy0(nbequa), resu(nbequa*2)
!
    integer      :: nbdecp
    real(kind=8) :: errmax
!
    real(kind=8) :: precis
    parameter (precis=1.0e-08)
!
    integer, parameter :: nbcar=2
    real(kind=8)       :: valcar(nbcar)
    integer            :: codcar(nbcar)
!
! --------------------------------------------------------------------------------------------------
!
!   loi de comportement non-linéaire : récupération du temps + et - , calcul de dt
    call jevech('PINSTPR', 'L', jtp)
    call jevech('PINSTMR', 'L', jtm)
    temps0 = zr(jtm)
    temps1 = zr(jtp)
    dtemps = temps1 - temps0
!   contrôle de rk5 : découpage successif, erreur maximale
    call jevech('PCARCRI', 'L', icarcr)
!   nombre d'itérations maxi (ITER_INTE_MAXI)
    nbdecp = int(zr(icarcr))
!   tolérance de convergence (RESI_INTE_RELA)
    errmax = zr(icarcr+2)
!   Température à t-
    call rcvarc(' ', 'TEMP', '-', fami, kpg, ksp, temper0, iret0)
    if ( iret0 .ne. 0 ) then
        temper0 = 0.0
    endif
!   Température à t+
    call rcvarc(' ', 'TEMP', '+', fami, kpg, ksp, temper1, iret1)
    if ( iret1 .ne. 0 ) then
        temper1 = 0.0
    endif
    ASSERT(iret0.eq.iret1)
!
!   Paramètres de la loi : imate nomat frpg
    ldcpai(1) = imate
    ldcpac(1) = ' '
    ldcpar(1) = 0.0
!
!   On recherche F_PRG
    call rcvala(imate,' ','RELAX_ACIER', &
                0, '  ', [0.0D+00], 1, 'F_PRG', valcar , codcar, 0)
!   Si on n'a pas trouvé F_PRG, on cherche ailleurs. Si on ne le trouve pas <F>. C'est un réel.
    if ( codcar(1).ne.0 ) then
        valcar(:) = 0.0
        call rcvala(imate,' ','BPEL_ACIER', &
                    0, ' ', [0.0D+00], 1, 'F_PRG', valcar , codcar, 0)
        if ( codcar(1).eq.0 ) then
            ldcpar(1) = valcar(1)
        else
            call rcvala(imate,' ','ETCC_ACIER', &
                        0, ' ', [0.0D+00], 1, 'F_PRG', valcar , codcar, 0)
            if ( codcar(1).eq.0 ) then
                ldcpar(1) = valcar(1)
            else
                call utmess('F', 'MODELISA2_46')
            endif
        endif
    endif
!
!   Si on trouve RELAX_1000 <A MODELISA2_45>
    call rcvala(imate,' ','BPEL_ACIER', &
                0, ' ', [0.0D+00], 1, 'RELAX_1000', valcar , codcar, 0)
    if ( codcar(1).eq.0 ) then
        if ( valcar(1) .gt. 0.0 ) then
            call utmess('A', 'MODELISA2_45', sk='BPEL_ACIER',sr=valcar(1))
        endif
    else
        call rcvala(imate,' ','ETCC_ACIER', &
                    0, ' ', [0.0D+00], 1, 'RELAX_1000', valcar , codcar, 0)
        if ( codcar(1).eq.0 ) then
            if ( valcar(1) .gt. 0.0 ) then
                call utmess('A', 'MODELISA2_45', sk='ETCC_ACIER',sr=valcar(1))
            endif
        endif
    endif
!
!   Équations du système :
!              1      2     3      4
!       yy   : sigma, epsi, epsiv, Temper
!       vari : epsiv  raideur
!
!   Variable à t-
    y0(1) = sigm
    y0(2) = epsm
    y0(3) = vim(1)
    y0(4) = temper0
!   Incréments
    dy0(2) = deps/dtemps
    dy0(4) = (temper1 - temper0)/dtemps
!
    call rk5adp(nbequa, ldcpar, ldcpai, ldcpac, temps0, dtemps, nbdecp,&
                errmax, y0, dy0, relax_cable, resu, iret1)
    sigp   = resu(1)
    vip(1) = resu(3)
    if (abs(resu(nbequa+2)) .gt. precis) then
        dsde = resu(nbequa + 1)/resu(nbequa + 2)
    else
        dsde = vim(2)
    endif
    if ( abs(dsde) .lt. precis ) then
!       Caractéristiques élastiques a t+
        call rcvalb(fami,kpg,ksp,'+',imate,' ','ELAS', &
                    0, ' ', [0.d0], 1, 'E', valcar, codcar, 1)
        dsde   = valcar(1)
    endif
    vip(2) = dsde
end subroutine
