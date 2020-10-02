! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504,W0104
!
subroutine lc0050(BEHinteg,&
                  fami   , kpg   , ksp   , ndim  , typmod,&
                  imate  , compor, carcri, instam, instap,&
                  neps   , epsm  , deps  , nsig  , sigm  ,&
                  nvi    , vim   , option, angmas,&
                  stress , statev, dsidep, codret)
!
use calcul_module, only : ca_iactif_
use Behaviour_type
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterc/umatwp.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcicma.h"
#include "asterfort/matrot.h"
#include "asterfort/rcvarc.h"
#include "asterfort/tecael.h"
#include "asterfort/mat_proto.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
#include "asterfort/umatPrepareStrain.h"
#include "asterfort/Behaviour_type.h"
!
type(Behaviour_Integ), intent(in) :: BEHinteg
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp, ndim
character(len=8), intent(in) :: typmod(*)
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: instam, instap
integer, intent(in) :: neps, nsig, nvi
real(kind=8), intent(in) :: epsm(6), deps(6)
real(kind=8), intent(in) :: sigm(6)
real(kind=8), intent(in) :: vim(*)
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angmas(*)
real(kind=8), intent(out) :: stress(6)
real(kind=8), intent(out) :: statev(nvi)
real(kind=8), intent(out) :: dsidep(6, 6)
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! UMAT : INTERFACE POUR ROUTINE D'INTEGRATION LOI DE COMPORTEMENT UMAT
!
! --------------------------------------------------------------------------------------------------
! 
! In  BEHinteg         : parameters for integration of behaviour
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
!            NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
!            IMATE    ADRESSE DU MATERIAU CODE
!            COMPOR    COMPORTEMENT DE L ELEMENT
!                COMPOR(1) = RELATION DE COMPORTEMENT (UMAT)
!                COMPOR(2) = NB DE VARIABLES INTERNES
!                COMPOR(3) = TYPE DE DEFORMATION(PETIT,GDEF_LOG)
!            CRIT    CRITERES  LOCAUX, INUTILISES PAR UMAT
!            INSTAM   INSTANT T
!            INSTAP   INSTANT T+DT
!            EPSM   DEFORMATION TOTALE A T EVENTUELLEMENT TOURNEE
!                   DANS LE REPERE COROTATIONNEL SI GDEF_LOG
!            DEPS   INCREMENT DE DEFORMATION EVENTUELLEMENT TOURNEE
!                   DANS LE REPERE COROTATIONNEL SI GDEF_LOG
!            SIGM   CONTRAINTE A T EVENTUELLEMENT TOURNEE...
!            VIM    VARIABLES INTERNES A T + INDICATEUR ETAT T
! ATTENTION : SI MODELE CINEMATIQUE ET GDEF, MODIFIER AUSSI VICIN0.F
!            OPTION     OPTION DE CALCUL A FAIRE
!                          'RIGI_MECA_TANG'> DSIDEP(T)
!                          'FULL_MECA'     > DSIDEP(T+DT) , SIG(T+DT)
!                          'RAPH_MECA'     > SIG(T+DT)
!            ANGMAS  ANGLES DE ROTATION DU REPERE LOCAL, CF. MASSIF
!            TYPMOD  TYPE DE MODELISATION (3D, AXIS, D_PLAN)
!            ICOMP   NUMERO DU SOUS-PAS DE TEMPS (CF. REDECE.F)
!            NVI     NOMBRE TOTAL DE VARIABLES INTERNES (+9 SI GDEF_HYP)
!            TEMP    TEMPERATURE A T
!            DTEMP   INCREMENT DE TEMPERATURE
!            PREDEF  VARIABLES DE COMMANDE A T
!            DPRED   INCREMENT DE VARIABLES DE COMMANDE  
!       OUT  STRESS    CONTRAINTE A T+DT
! !!!!!        ATTENTION : ZONE MEMOIRE NON DEFINIE SI RIGI_MECA_TANG
!            STATEV  VARIABLES INTERNES A T+DT
! !!!!!        ATTENTION : ZONE MEMOIRE NON DEFINIE SI RIGI_MECA_TANG
!            DSIDEP  MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
!            CODRET  CODE-RETOUR = 0 SI OK, =1 SINON
! ======================================================================
!     NTENS  :  NB TOTAL DE COMPOSANTES TENSEURS
!     NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
! ======================================================================
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: npropmax = 197
    real(kind=8) :: props(npropmax)
    integer :: nprops, pfumat
    integer :: nshr, i, nstatv, npt, noel, layer
    integer :: kspt, kstep, kinc, j
    integer:: jv_iterat, iadzi, iazk24
    real(kind=8) :: drott(3, 3), drot(3, 3), dstran(9), stran(9)
    real(kind=8) :: sse, spd, scd, rpl
    real(kind=8) :: time(2), dtime, pnewdt
    real(kind=8) :: ddsdde(36), dfgrd0(3, 3), dfgrd1(3, 3)
    real(kind=8) :: ddsddt(6), drplde(6), drpldt
    real(kind=8) :: coords(3), celent
    character(len=16) :: rela_comp
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8), parameter :: usrac2 = sqrt(2.d0)*0.5d0
    character(len=80) :: cmname
    real(kind=8) :: temp, dtemp
!
    integer :: ntens, ndi
    common/tdim/ntens, ndi
!
! --------------------------------------------------------------------------------------------------
!
    ntens     = 2*ndim
    ndi       = 3
    nshr      = ntens-ndi
    codret    = 0
    nprops    = npropmax
    rela_comp = compor(RELA_NAME)
!
! - Pointer to UMAT function
!
    pfumat = int(carcri(EXTE_PTR))
!
! - Get temperature
!
    temp  = BEHinteg%esva%temp_prev
    dtemp = BEHinteg%esva%temp_incr
!
! - Get index of element / Newton iteration
!
    if (ca_iactif_ .ne. 2) then 
        if (option(1:9) .eq. 'RIGI_MECA') then
            kinc = 0
        else
            call jevech('PITERAT', 'L', jv_iterat)
            kinc = zi(jv_iterat)
        end if
        call tecael(iadzi, iazk24, noms=0)
        noel = zi(iadzi)
    else 
        kinc = 0
        noel = 1
    end if
!
! - Coordinates of current Gauss point
!
    coords(ndim+1:) = BEHinteg%elem%coor_elga(kpg, 1:ndim)
!
! - Get material properties
!
    call mat_proto(BEHinteg,&
                   fami    , kpg  , ksp, '+', imate, compor(1),&
                   nprops  , props)
!
! - Prepare strains
!
    call umatPrepareStrain(neps , epsm , deps ,&
                           stran , dstran, dfgrd0, dfgrd1)
!
! - Number of internal state variables
!
    nstatv = nvi
!
! - Get time
!
    time(1) = instap-instam
    time(2) = instam
    dtime   = instap-instam
!
! - Anisotropic case
!
    call matrot(angmas, drott)
    do i = 1, 3
        do j = 1, 3
            drot(j,i) = drott(i,j)
        end do
    end do
!
! - Transfer some variables from aster to UMAT
!
    celent = 0.d0
    npt    = kpg
    layer  = 1
    kspt   = ksp
    kstep  = 1
    cmname = rela_comp
    pnewdt = 1.d0
!
! - Unused variables in UMAT
!
    sse    = 0.d0
    spd    = 0.d0
    scd    = 0.d0
    rpl    = 0.d0
    ddsddt = 0.d0
    drplde = 0.d0
    drpldt = 0.d0
!
! - Run UMAT
!
    pnewdt = 1.d0
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dcopy(nsig, sigm, 1, stress, 1)
        call dscal(3, usrac2, stress(4), 1)
        call lceqvn(nstatv, vim, statev)
        call umatwp(pfumat, stress, statev, ddsdde,&
                    sse, spd, scd, rpl, ddsddt,&
                    drplde, drpldt, stran, dstran, time,&
                    dtime, temp, dtemp,&
                    BEHinteg%exte%predef, BEHinteg%exte%dpred,&
                    cmname, ndi, nshr, ntens, nstatv,&
                    props, nprops, coords, drot, pnewdt,&
                    celent, dfgrd0, dfgrd1, noel, npt,&
                    layer, kspt, kstep, kinc)
    else if (option(1:9).eq. 'RIGI_MECA') then
        dstran = 0.d0
        call umatwp(pfumat, sigm, vim, ddsdde,&
                    sse, spd, scd, rpl, ddsddt,&
                    drplde, drpldt, stran, dstran, time,&
                    dtime, temp, dtemp,&
                    BEHinteg%exte%predef, BEHinteg%exte%dpred,&
                    cmname, ndi, nshr, ntens, nstatv,&
                    props, nprops, coords, drot, pnewdt,&
                    celent, dfgrd0, dfgrd1, noel, npt,&
                    layer, kspt, kstep, kinc)
    endif
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dscal(3, rac2, stress(4), 1)
    endif
!
    if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        dsidep = 0.d0
        call lcicma(ddsdde, ntens, ntens, ntens, ntens,  1, 1, dsidep, 6, 6, 1, 1)
        do i = 1, 6
            do j = 4, 6
                dsidep(i,j) = dsidep(i,j)*rac2
            end do
        end do
        do i = 4, 6
            do j = 1, 6
                dsidep(i,j) = dsidep(i,j)*rac2
            end do
        end do
     endif
!
! - Rerturn code
!
    if (pnewdt .lt. 0.99d0) then
        codret=1
    endif
!
end subroutine
