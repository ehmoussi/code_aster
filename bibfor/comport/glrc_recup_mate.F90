! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine glrc_recup_mate(imate, compor, lrgm, ep, lambda, deuxmu, lamf, deumuf, gt, gc, gf, &
                           seuil, alpha, alfmc, epsic, epsiels, epsilim,&
                           is_param_opt_, val_param_opt_)
! person_in_charge: sebastien.fayolle at edf.fr
! aslint: disable=W1504
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    aster_logical, intent(in) :: lrgm
    character(len=16), intent(in) :: compor
    integer, intent(in) :: imate
    real(kind=8), intent(in) :: ep
    real(kind=8), optional, intent(out) :: lambda, deuxmu, deumuf, lamf
    real(kind=8), optional, intent(out) :: gt, gc, gf, seuil, alpha, alfmc
    real(kind=8), optional, intent(out) :: epsic, epsiels, epsilim, val_param_opt_(*)
    aster_logical, optional, intent(out) :: is_param_opt_(*)
! ----------------------------------------------------------------------
!
! BUT : LECTURE DES PARAMETRES MATERIAU POUR LE MODELE GLRC_DM
!
!
! IN:
!       IMATE   : ADRESSE DU MATERIAU
!       COMPOR  : COMPORTMENT
!       EP      : EPAISSEUR DE LA PLAQUE
! OUT:
!       LAMBDA  : PARAMETRE D ELASTICITE - MEMBRANE
!       DEUXMU  : PARAMETRE D ELASTICITE - MEMBRANE
!       LAMF    : PARAMETRE D ELASTICITE - FLEXION
!       DEUMUF  : PARAMETRE D ELASTICITE - FLEXION
!       GT      : PARAMETRE GAMMA POUR LA MEMBRANE EN TRACTION
!       GC      : PARAMETRE GAMMA POUR LA MEMBRANE EN COMPRESSION
!       GF      : PARAMETRE GAMMA POUR LA FLEXION
!       SEUIL   : INITIAL MEMBRANE
!       ALPHA   : PARAMETRE DE SEUIL FLEXION
!       ALFMC   : PARAMETRE DE DECOUPLAGE SEUILS TRACTION-COMPRESSION
!       EPSIC   : DEFORMATION AU PIC DE COMPRESSION
!       EPSIELS : DEFORMATION DES ACIERS A L'ETAT ULTIME DE SERVICE
!       EPSILIM : DEFORMATION A RUPTURE DES ACIERS
! ----------------------------------------------------------------------
!
    integer :: icodre(16)
    real(kind=8) :: valres(16), e, nu, ef
    real(kind=8) :: nyt, nyc, myf, nuf, delas(6, 6)
    real(kind=8) :: lambda_int, deuxmu_int, deumuf_int, lamf_int
    real(kind=8) :: gt_int, gc_int, gf_int, seuil_int, alpha_int, alfmc_int
    real(kind=8) :: epsi_c, epsi_els, epsi_lim
    character(len=16) :: nomres(16)
!
    if ((.not.( compor(1:7) .eq. 'GLRC_DM'))) then
        call utmess('F', 'ELEMENTS4_65', sk=compor)
    endif
!
    call r8inir(6*6, 0.0d0, delas, 1)
    call r8inir(10, 0.0d0, valres, 1)
!
!    LECTURE DES CARACTERISTIQUES DU MATERIAU
    nomres(1) = 'E_M'
    nomres(2) = 'NU_M'
!
    call rcvala(imate, ' ', 'ELAS_GLRC', 0, ' ',&
                    [0.d0], 2, nomres, valres, icodre,1)
!
    e = valres(1)
    nu = valres(2)
    lambda_int = e * nu / (1.d0+nu) / (1.d0 - 2.d0*nu)*ep
    deuxmu_int = e/(1.d0+nu)*ep
!
    nomres(1) = 'E_F'
    nomres(2) = 'NU_F'
!
    call rcvala(imate, ' ', 'ELAS_GLRC', 0, ' ',&
                [0.d0], 2, nomres, valres, icodre,&
                0)
!
    if (icodre(1) .eq. 0) then
        ef = valres(1)
    else
        ef = e
    endif
!
    if (icodre(2) .eq. 0) then
        nuf = valres(2)
    else
        nuf = nu
    endif
!
    lamf_int = ef*nuf/(1.d0-nuf*nuf) *ep**3/12.0d0
    deumuf_int = ef/(1.d0+nuf) *ep**3/12.0d0
!
!    LECTURE DES CARACTERISTIQUES D'ENDOMMAGEMENT
    nomres(1) = 'GAMMA_T'
    nomres(2) = 'GAMMA_C'
    nomres(3) = 'GAMMA_F'
    nomres(4) = 'NYT'
    nomres(5) = 'NYC'
    nomres(6) = 'MYF'
    nomres(7) = 'ALPHA_C'
    nomres(8) = 'EPSI_C'
    nomres(9) = 'EPSI_ELS'
    nomres(10) = 'EPSI_LIM'
    nomres(11) = 'RX'
    nomres(12) = 'OMX'
    nomres(13) = 'EA'
    nomres(14) = 'SY'
    nomres(15) = 'FTJ'
    nomres(16) = 'FCJ'
    call rcvala(imate, ' ', 'GLRC_DM', 0, ' ',&
                [0.d0], 16, nomres, valres, icodre,&
                0)
!
    gt_int = valres(1)
    gc_int = valres(2)
    gf_int = valres(3)
    nyt = valres(4)
    nyc = valres(5)
    myf = valres(6)
    alfmc_int = valres(7)
    epsi_c = valres(8)
    epsi_els = valres(9)
    epsi_lim = valres(10)
!
    if (gc_int .eq. 1.d0 .and. gt_int .eq. 1.d0) then
        call utmess('F', 'ALGORITH6_1')
    endif
!
!    if (icodre(7) .eq. 0 .and. gc_int .ne. 1.d0) then
!        alfmc_int = valres(7)
!    else
!        if (gc_int .eq. 1.d0) then
!            alfmc_int = 1.d0
!        else
!            alfmc_int=(1.d0-gc_int)*(nyc**2*(1.d0-nu)*(1.d0+2.d0*nu)/nyt**2-nu**2)&
!                    /((1.d0-gt_int)*((1.d0-nu)*(1.d0+2.d0*nu)-(nu*nyc/nyt)**2))
!        endif
!    endif

!    alpha_c etant obligatoire le bloc en commentaire est equivalent a :
     
    if (gc_int .eq. 1.d0) then
        alfmc_int = 1.d0
    endif
!
!    CALCUL DU SEUIL (k0 DANS R7.01.32) ET DE ALPHA
    if (lrgm) then
        alpha_int = 1.d0
        alfmc_int = 1.d0
        seuil_int = 0.d0
    else
        seuil_int = lambda_int*(1.0d0 - gt_int)*(1.0d0-2.0d0*nu)**2 &
                  + deuxmu_int*( 1.0d0 - gt_int + (1.0d0 - gc_int)*nu**2/alfmc_int)
!
        seuil_int = seuil_int/(2.0d0*(lambda_int*(1.0d0-2.0d0*nu) + deuxmu_int))**2
        seuil_int = seuil_int*nyt**2
!
        if (seuil_int .ne. 0.d0) then
            alpha_int = lamf_int*(1.0d0-nuf)**2 + deumuf_int
            alpha_int = alpha_int/(2.0d0*(lamf_int*(1.0d0-nuf) + deumuf_int)**2)
            alpha_int = alpha_int*(1.0d0 - gf_int)*myf**2/seuil_int
        else
            call utmess('F', 'ALGORITH6_3')
        endif
    endif
!
    if (present(lambda)) then
        lambda = lambda_int
    endif
    if (present(deuxmu)) then
        deuxmu = deuxmu_int
    endif
    if (present(deumuf)) then
        deumuf = deumuf_int
    endif
    if (present(lamf)) then
        lamf = lamf_int
    endif
    if (present(gt)) then
        gt = gt_int
    endif
    if (present(gc)) then
        gc = gc_int
    endif
    if (present(gf)) then
        gf = gf_int
    endif
    if (present(seuil)) then
        seuil = seuil_int
    endif
    if (present(alpha)) then
        alpha = alpha_int
    endif
    if (present(alfmc)) then
        alfmc = alfmc_int
    endif
    if (present(epsic)) then
        epsic = epsi_c
    endif
    if (present(epsiels)) then
        epsiels = epsi_els
    endif
    if (present(epsilim)) then
        epsilim = epsi_lim
    endif
    if (present(is_param_opt_)) then
        ASSERT(present(val_param_opt_))
        is_param_opt_(1:2) = .false.
!       RX
        if (icodre(11).eq. 0)then
            is_param_opt_(1) = .true.
            val_param_opt_(1) = valres(11)
!           OMX, EA, SY, FTJ, FCJ, KAPPA_FLEX + EM, EF, NYC, MYF
            if (icodre(12).eq. 0)then
                is_param_opt_(2) = .true.
                val_param_opt_(2) = valres(12)
                val_param_opt_(3) = valres(13)
                val_param_opt_(4) = valres(14)
                val_param_opt_(5) = valres(15)
                val_param_opt_(6) = valres(16)
                val_param_opt_(7) = e
                val_param_opt_(8) = ef
                val_param_opt_(9) = nyc
                val_param_opt_(10) = myf
            endif
        endif
    endif
!
end subroutine
