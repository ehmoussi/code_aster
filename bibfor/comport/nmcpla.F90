! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine nmcpla(fami, kpg   , ksp  , ndim  , typmod,&
                  imat, compor_plas, compor_creep, carcri , timed , timef ,&
                  neps, epsdt , depst, nsig  , sigd  ,&
                  vind, option, nwkin, wkin  , sigf  ,&
                  vinf, ndsde , dsde , nwkout, wkout ,&
                  iret)
!
use calcul_module, only : ca_ctempl_, ca_ctempr_, ca_ctempm_, ca_ctempp_
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/granvi.h"
#include "asterfort/lcopil.h"
#include "asterfort/lcprmv.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmgran.h"
#include "asterfort/nmisot.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/redece.h"
#include "asterfort/rslnvi.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
! aslint: disable=W1504
!
    integer :: imat, ndim, kpg, ksp, iret
    integer :: neps, nsig, nwkin, nwkout, ndsde
    character(len=16), intent(in) :: compor_plas(*)
    character(len=16), intent(in) :: compor_creep(*)
    real(kind=8), intent(in) :: carcri(*)
    real(kind=8) :: timed, timef, tempd, tempf, tref
    real(kind=8) :: wkin(*), wkout(*)
    real(kind=8) :: epsdt(6), depst(6)
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: vind(*), vinf(*)
    real(kind=8) :: dsde(ndsde)
    character(len=16) :: option
    character(len=*) :: fami
    character(len=8) :: typmod(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment management
!
! KIT_DDI with creeping = GRANGER
!
! --------------------------------------------------------------------------------------------------
!
!       INTEGRATION DU COUPLAGE FLUAGE/FISSURATION, C'EST A DIRE LE
!       COUPLAGE D'UNE LOI DE COMPORTEMENT DE TYPE FLUAGE GRANGER
!       ET D'UNE LOI DE  COMPORTEMENT ELASTO PLASTIQUE
!               AVEC    . N VARIABLES INTERNES
!                       . UNE FONCTION SEUIL ELASTIQUE
!
!       INTEGRATION DES CONTRAINTES           = SIG(T+DT)
!       INTEGRATION DES VARIABLES INTERNES    = VIN(T+DT) (CUMUL DES
!              VARIABLES INTERNES DES DEUX LOIS)
!       ET CALCUL DU JACOBIEN ASSOCIE         = DS/DE(T+DT) OU DS/DE(T)
!
!       ================================================================
!       ARGUMENTS
!
!       IN      KPG,KSP  NUMERO DU (SOUS)POINT DE GAUSS
!               NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
!               TYPMOD  TYPE DE MODELISATION
!               IMAT    ADRESSE DU MATERIAU CODE
!               COMP    COMPORTEMENT DE L ELEMENT
!                       COMP(1) = RELATION DE COMPORTEMENT
!                       COMP(2) = NB DE VARIABLES INTERNES
!                       COMP(3) = TYPE DE DEFORMATION (PETIT,JAUMANN...)
!               OPT     OPTION DE CALCUL A FAIRE
!                               'RIGI_MECA_TANG'> DSDE(T)
!                               'FULL_MECA'     > DSDE(T+DT) , SIG(T+DT)
!                               'RAPH_MECA'     > SIG(T+DT)
!               CRIT    CRITERES  LOCAUX
!                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
!                                 (ITER_INTE_MAXI == ITECREL)
!                       CRIT(2) = TYPE DE JACOBIEN A T+DT
!                                 (TYPE_MATR_COMP == MACOMP)
!                                 0 = EN VITESSE     > SYMETRIQUE
!                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
!                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
!                                 (RESI_INTE_RELA == RESCREL)
!                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
!                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
!                                 (ITER_INTE_PAS == ITEDEC)
!                                 0 = PAS DE REDECOUPAGE
!                                 N = NOMBRE DE PALIERS
!               WKIN  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
!                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
!                       FIXEE EN DUR)
!               TIMED   INSTANT T
!               TIMEF   INSTANT T+DT
!               EPSDT   DEFORMATION TOTALE A T
!               DEPST   INCREMENT DE DEFORMATION TOTALE
!               SIGD    CONTRAINTE A T
!               VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
!       OUT     SIGF    CONTRAINTE A T+DT
!               VINF    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
!               DSDE    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
!               IRET    CODE RETOUR DE L'INTEGRATION INTEGRATION DU
!                       COUPLAGE FLUAGE/FISSURATION
!                              IRET=0 => PAS DE PROBLEME
!                              IRET=1 => ABSENCE DE CONVERGENCE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ndt_local, ndi_local
    integer :: ndt, ndi
    integer :: nvi_flua, nvi_plas, idx_vi_plas
    integer :: i, retcom, ire2, iret1, iret2, iret3
    integer :: nume_plas, nume_flua
    integer :: k, iter, itemax
    integer :: cerr(5)
    character(len=8) :: elem_model, nomc(5)
    character(len=16) :: rela_flua, rela_plas
    real(kind=8) :: nu, angmas(3)
    real(kind=8) :: espi_creep(6), epsfld(6), epsflf(6), depsfl(6)
    real(kind=8) :: deps(6), kooh(6, 6)
    real(kind=8) :: materd(5), materf(5), depst2(6), depsel(6)
    real(kind=8) :: epsicv, toler, ndsig, nsigf
    real(kind=8) :: dsigf(6), hydrd, hydrf, sechd, sechf, sref
    real(kind=8) :: epseld(6), epself(6), epsthe
    real(kind=8) :: sigf2(6)
    real(kind=8) :: tmpdmx, tmpfmx, epsth
    real(kind=8) :: alphad, alphaf, bendod, bendof, kdessd, kdessf
    aster_logical :: l_inte_forc
!
! --------------------------------------------------------------------------------------------------
!
    common /tdim/   ndt, ndi
!
! --------------------------------------------------------------------------------------------------
!
    l_inte_forc = option .eq. 'RAPH_MECA' .or. option .eq. 'FULL_MECA'
    rela_flua   = compor_creep(RELA_NAME)
    rela_plas   = compor_plas(RELA_NAME)
    elem_model  = typmod(1)
    read (compor_creep(NVAR),'(I16)') nvi_flua
    read (compor_plas(NVAR) ,'(I16)') nvi_plas
    read (compor_plas(NUME) ,'(I16)') nume_plas
    read (compor_creep(NUME),'(I16)') nume_flua
    ASSERT(compor_creep(RELA_NAME)(1:13) .eq. 'BETON_GRANGER')
!
! - Get size for tensors
!
    ndt_local = 2*ndim
    ndi_local = 3
!
! - Get temperatures
!
    call rcvarc(' ', 'TEMP', '-', fami, kpg, ksp, tempd, iret1)
    call rcvarc(' ', 'TEMP', '+', fami, kpg, ksp, tempf, iret2)
    call rcvarc(' ', 'TEMP', 'REF', fami, kpg, ksp, tref, iret3)
!
! - Get maximum temperature during load (for BETON_DOUBLE_DP)
!
    tmpdmx = tempd
    tmpfmx = tempf
    if (rela_plas.eq. 'BETON_DOUBLE_DP' ) then
        if (((iret1+iret2).eq.0) .and. (.not.isnan(vind(nvi_flua+3)))) then
            if (tmpdmx .lt. vind(nvi_flua+3)) then
                tmpdmx = vind(nvi_flua+3)
            endif
            if (tmpfmx .lt. vind(nvi_flua+3)) then
                tmpfmx = vind(nvi_flua+3)
            endif
        endif
    endif
!
! - Set temperature access
!
    ca_ctempl_ = 1
    ca_ctempm_ = tmpdmx
    ca_ctempp_ = tmpfmx
    ca_ctempr_ = tref
!
! - Get convergence criteria
!
    itemax = int(carcri(1))
    toler  = carcri(3)
!
! = COUPLING = BEGIN
!
    iter = 1
    depst2(1:6) = depst(1:6)
!
 20 continue
!
! - Solve creep law
!
    if (l_inte_forc) then
!
! ----- Solve creep law
!
        call nmcomp(fami, kpg, ksp, ndim, typmod,&
                    imat, compor_creep, carcri, timed, timef  ,&
                    neps, epsdt, depst2, nsig, sigd,&
                    vind, option, angmas, nwkin, wkin,&
                    sigf2, vinf, ndsde, dsde, nwkout,&
                    wkout, iret)
!
! ----- Get material parameters
!
        nomc(1) = 'E       '
        nomc(2) = 'NU      '
        nomc(3) = 'ALPHA   '
        nomc(4) = 'B_ENDOGE'
        nomc(5) = 'K_DESSIC'
        call rcvalb(fami, 1, 1, '+', imat,&
                    ' ', 'ELAS', 1, 'TEMP', [tmpdmx],&
                    1, nomc(2), materd(2), cerr(1), 2)
        call rcvalb(fami, 1, 1, '+', imat,&
                    ' ', 'ELAS', 1, 'TEMP', [tmpfmx],&
                    1, nomc(2), materf(2), cerr(1), 2)
        materd(1) = 1.d0
        materf(1) = 1.d0
!
! ----- Creep strains - At beginning of step
!
        do k = 1, ndt_local
            espi_creep(k) = vind(8*ndt_local+k)
            do i = 1, 8
                espi_creep(k) = espi_creep(k) - vind((i-1) * ndt_local+k)
            enddo
        enddo
        call lcopil('ISOTROPE', elem_model, materd, kooh)
        call lcprmv(kooh, espi_creep, epsfld)
!
! ----- Creep strains - At end of step
!
        do k = 1, ndt_local
            espi_creep(k) = vinf(8*ndt_local+k)
            do i = 1, 8
                espi_creep(k) = espi_creep(k) - vinf((i-1) * ndt_local+k)
            enddo
        enddo
        call lcopil('ISOTROPE', elem_model, materf, kooh)
        call lcprmv(kooh, espi_creep, epsflf)
!
! ----- Creep strain increment
!
        do k = 1, ndt_local
            depsfl(k) = epsflf(k) - epsfld(k)
        enddo
    endif
!
! - Unset temperature access
!
    ca_ctempl_ = 0
!
! - Total strains
!
    if (l_inte_forc) then
        do k = 1, ndt_local
            deps(k) = depst(k) - depsfl(k)
        enddo
    else
        do k = 1, ndt_local
            deps(k) = depst(k)
        enddo
    endif
!
! - Solve plasticity law
!
    idx_vi_plas = nvi_flua + 1
    call nmcomp(fami, kpg, ksp, ndim, typmod,&
                imat, compor_plas, carcri, timed, timef  ,&
                neps, epsdt, deps, nsig, sigd,&
                vind(idx_vi_plas), option, angmas, nwkin, wkin,&
                sigf, vinf(idx_vi_plas), ndsde, dsde, nwkout,&
                wkout, retcom)
    if (retcom .eq. 1) then
        iret = 1
        goto 999
    endif
!
! - Change in common
!
    ndt = 2*ndim
    ndi = 3
!
! - Coupling algorithm
!
    if (l_inte_forc) then
!
! ----- Get material parameters
!
        call rcvalb(fami, kpg, ksp, '-', imat,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    5, nomc(1), materd(1), cerr(1), 2)
        if (cerr(3) .ne. 0) materd(3) = 0.d0
        if (cerr(4) .ne. 0) materd(4) = 0.d0
        if (cerr(5) .ne. 0) materd(5) = 0.d0
        call rcvalb(fami, kpg, ksp, '+', imat,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    5, nomc(1), materf(1), cerr(1), 2)
        if (cerr(3) .ne. 0) materf(3) = 0.d0
        if (cerr(4) .ne. 0) materf(4) = 0.d0
        if (cerr(5) .ne. 0) materf(5) = 0.d0
!
! ----- Elastic strain increment
!
        call lcopil('ISOTROPE', elem_model, materd, kooh)
        call lcprmv(kooh, sigd, epseld)
        call lcopil('ISOTROPE', elem_model, materf, kooh)
        call lcprmv(kooh, sigf, epself)
        do k = 1, ndt_local
            depsel(k) = epself(k) - epseld(k)
        enddo
!
! --- CALCUL DE L'INCREMENT DE DEFORMATION ELASTIQUE
! --- + RETRAIT ENDOGENNE + RETRAIT DESSICCATION + RETRAIT THERMIQUE
!
        alphad = materd(3)
        alphaf = materf(3)
        bendod = materd(4)
        bendof = materf(4)
        kdessd = materd(5)
        kdessf = materf(5)
        call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                    ksp, hydrd, ire2)
        if (ire2 .ne. 0) hydrd=0.d0
        call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                    ksp, hydrf, ire2)
        if (ire2 .ne. 0) hydrf=0.d0
        call rcvarc(' ', 'SECH', '-', fami, kpg,&
                    ksp, sechd, ire2)
        if (ire2 .ne. 0) sechd=0.d0
        call rcvarc(' ', 'SECH', '+', fami, kpg,&
                    ksp, sechf, ire2)
        if (ire2 .ne. 0) sechf=0.d0
        call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                    ksp, sref, ire2)
        if (ire2 .ne. 0) sref=0.d0
!
        if ((iret1+iret2+iret3) .ne. 0) then
            epsthe = 0.d0
        else
            epsthe = alphaf*(tempf-tref) - alphad*(tempd-tref)
        endif
        epsth = epsthe - bendof*hydrf + bendod*hydrd - kdessf*(sref- sechf) + kdessd*(sref-sechd)
        do k = 1, 3
            depsel(k) = depsel(k) + epsth
        enddo
!
! ----- For plane stress
!
        if (elem_model(1:6) .eq. 'C_PLAN') then
            nu = materf(2)
            depsel(3)=-nu / (1.d0-nu) * (depsel(1)+depsel(2)) +(1.d0+nu) / (1.d0-nu) * epsth
        endif
!
! ---    CALCUL DE L'INCREMENT DE DEFORMATION EN ENTREE DU CALCUL
! ---    DE FLUAGE POR L'ITERATION SUIVANTE
!
        do k = 1, ndt_local
            depst2(k) = depst2(k) + depsel(k) + depsfl(k) - depst2(k)
        enddo
!
! ---    CRITERE DE CONVERGENCE - NORME DE SIGF2 - SIGF
!
        do k = 1, ndt_local
            dsigf(k) = sigf2(k) - sigf(k)
        enddo
!
        ndsig = 0.d0
        nsigf = 0.d0
        do k = 1, ndt_local
            ndsig = ndsig + dsigf(k) * dsigf(k)
            nsigf = nsigf + sigf(k) * sigf(k)
        enddo
!
        if (nsigf .gt. toler*toler) then
            epsicv = (ndsig/nsigf) ** 0.5d0
        else
            epsicv = ndsig ** 0.5d0
        endif
!
        if (epsicv .gt. toler) then
            if (iter .lt. itemax) then
                iter = iter + 1
                goto 20
            else
                iret = 1
                goto 999
            endif
        endif
    endif
!
! = COUPLING = END
!
999 continue
end subroutine
