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
!aslint: disable=W1504,W0104

subroutine lc0050(fami, kpg, ksp, ndim, typmod,&
                  imate, compor, crit, instam, instap,&
                  neps, epsm, deps, nsig, sigm,&
                  nvi, vim, option, angmas, icomp, &
                  temp , dtemp , predef, dpred ,&
                  stress, statev, ndsde, dsidep, codret)
!
use calcul_module, only : ca_iactif_
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterc/umatwp.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jevech.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcicma.h"
#include "asterfort/matrot.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvarc.h"
#include "asterfort/tecael.h"
#include "asterfort/mat_proto.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
#include "asterfort/umatPrepareStrain.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp, ndim
character(len=8), intent(in) :: typmod(*)
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*)
real(kind=8), intent(in) :: crit(*)
real(kind=8), intent(in) :: instam, instap
integer, intent(in) :: neps, nsig, nvi
real(kind=8), intent(in) :: epsm(6), deps(6)
real(kind=8), intent(in) :: sigm(6)
real(kind=8), intent(in) :: vim(*)
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angmas(*)
integer, intent(in) :: icomp
real(kind=8), intent(in) :: temp, dtemp
real(kind=8), intent(in) :: predef(*), dpred(*) 
real(kind=8), intent(out) :: stress(6)
real(kind=8), intent(out) :: statev(nvi)
integer, intent(out) :: ndsde
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
!       IN   FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!            KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
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
    integer ::      nprops, pfumat
    integer ::      ntens, ndi, nshr, i, nstatv, npt, noel, layer
    integer ::      kspt, kstep, kinc, idbg, j, ifm, niv
    integer:: jiterat, iadzi, iazk24, iretx,irety,iretz
    integer, parameter :: npropmax = 197
    integer, parameter :: npred = 8
    real(kind=8) :: drott(3, 3), drot(3, 3), dstran(9), stran(9)
    real(kind=8) :: props(npropmax)
    real(kind=8) :: sse, spd, scd, rpl
    real(kind=8) :: time(2), dtime, pnewdt
    real(kind=8) :: ddsdde(36), dfgrd0(3, 3), dfgrd1(3, 3)
    real(kind=8) :: ddsddt(6), drplde(6), drpldt
    real(kind=8) :: coords(3), celent
    real(kind=8) :: rac2, usrac2
    character(len=80) :: cmname
    character(len=8)   :: lvarc(npred)
!
    common/tdim/  ntens  , ndi
    data idbg/1/
    data lvarc/'SECH','HYDR','IRRA','NEUT1','NEUT2','CORR','ALPHPUR','ALPHBETA'/
!
! --------------------------------------------------------------------------------------------------
!
    ntens=2*ndim
    ndi=3
    nshr=ntens-ndi
    codret=0
    rac2=sqrt(2.d0)
    usrac2=rac2*0.5d0
    nprops = npropmax
!
!     IMPRESSIONS EVENTUELLES EN DEBUG
    call infniv(ifm, niv)
!
    if ((niv.ge.2) .and. (idbg.eq.1)) then
        write(ifm,*)'TEMPERATURE ET INCREMENT'
        write(ifm,'(2(1X,E11.4))') temp,dtemp
        write(ifm,*) 'AUTRES VARIABLES DE COMMANDE ET INCREMENTS'
        do i = 1, npred
            write(ifm,'(A8,2(1X,E11.4))') lvarc(i),predef(i),dpred(i)
        enddo
    endif
!
!     SI ON NE TRAVAILLE PAS AVEC CALC_POINT_MAT, RECUPERATION DU NUM DE L'ITERATION ET DE LA MAILLE
    if (ca_iactif_ .ne. 2) then 
    
    !   NUMERO DE L'ITERATION
        if (option(1:9).eq.'RIGI_MECA') then
            kinc=0
        else
            call jevech('PITERAT', 'L', jiterat)
            kinc = nint(zr(jiterat))
        end if

    !   NUMERO DE LA MAILLE
        call tecael(iadzi, iazk24, noms=0)
        noel = zi(iadzi)    
        
    else 
        kinc = 0
        noel = 1
    end if
!
!   COORDONNEES DU POINT D'INTEGRATION (NaN si absent)
    call rcvarc(' ', 'X', '+', fami, kpg,  ksp, coords(1), iretx)
    call rcvarc(' ', 'Y', '+', fami, kpg,  ksp, coords(2), irety)
    call rcvarc(' ', 'Z', '+', fami, kpg,  ksp, coords(3), iretz)
    if (iretx.ne.0) then
        coords = r8nnem()
    else
        coords(ndim+1:) = 0.d0
    end if
!
!   LECTURE DES PROPRIETES MATERIAU (MOT-CLE UMAT[_FO] DE DEFI_MATERIAU)
    call mat_proto(fami, kpg, ksp, '+', imate, compor(1), nprops, props)
!
!   PREPARATION DES DEFORMATIONS EN ENTREE DE LA LOI
    call umatPrepareStrain(neps , epsm , deps ,&
                           stran , dstran, dfgrd0, dfgrd1)
!
!   RENOMMAGE DE CERTAINES VARIABLES EN ACCORD AVEC STANDARD UMAT
    if (compor(3) .eq. 'GDEF_LOG') then
        nstatv=nvi-6
    else
        nstatv=nvi
    endif
!
    time(1)=instap-instam
    time(2)=instam
    dtime=instap-instam
    cmname=compor(1)
!
    call matrot(angmas, drott)
!
    do 100,i = 1,3
    do 90,j = 1,3
        drot(j,i) = drott(i,j)
 90 continue
100 continue
!
    celent=0.d0
    npt=kpg
    layer=1
    kspt=ksp
    kstep=icomp
!
!     INITIALISATIONS DES ARGUMENTS INUTILISES
    sse=0.d0
    spd=0.d0
    scd=0.d0
    rpl=0.d0
    call r8inir(6, 0.d0, ddsddt, 1)
    call r8inir(6, 0.d0, drplde, 1)
    drpldt=0.d0
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        if ((niv.ge.2) .and. (idbg.eq.1)) then
!
            write(ifm,*)' '
            write(ifm,*)'AVANT APPEL UMAT, INSTANT=',time(2)+dtime
            write(ifm,*)'DEFORMATIONS INSTANT PRECEDENT STRAN='
            write(ifm,'(6(1X,E11.4))') (stran(i),i=1,ntens)
            write(ifm,*)'ACCROISSEMENT DE DEFORMATIONS DSTRAN='
            write(ifm,'(6(1X,E11.4))') (dstran(i),i=1,ntens)
            write(ifm,*)'CONTRAINTES INSTANT PRECEDENT STRESS='
            write(ifm,'(6(1X,E11.4))') (sigm(i),i=1,ntens)
            write(ifm,*)'NVI=',nstatv,' VARIABLES INTERNES STATEV='
            write(ifm,'(10(1X,E11.4))') (vim(i),i=1,nstatv)
        endif
    endif
!
    pnewdt=1.d0
!!
    pfumat = int(crit(16))
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
!
        call dcopy(nsig, sigm, 1, stress, 1)
        call dscal(3, usrac2, stress(4), 1)
!
        call lceqvn(nstatv, vim, statev)
!
        call umatwp(pfumat, stress, statev, ddsdde,&
                    sse, spd, scd, rpl, ddsddt,&
                    drplde, drpldt, stran, dstran, time,&
                    dtime, temp, dtemp, predef, dpred,&
                    cmname, ndi, nshr, ntens, nstatv,&
                    props, nprops, coords, drot, pnewdt,&
                    celent, dfgrd0, dfgrd1, noel, npt,&
                    layer, kspt, kstep, kinc)
!
    else if (option(1:9).eq. 'RIGI_MECA') then
        call r8inir(6, 0.d0, dstran, 1)
        call umatwp(pfumat, sigm, vim, ddsdde,&
                    sse, spd, scd, rpl, ddsddt,&
                    drplde, drpldt, stran, dstran, time,&
                    dtime, temp, dtemp, predef, dpred,&
                    cmname, ndi, nshr, ntens, nstatv,&
                    props, nprops, coords, drot, pnewdt,&
                    celent, dfgrd0, dfgrd1, noel, npt,&
                    layer, kspt, kstep, kinc)
    endif
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        if ((niv.ge.2) .and. (idbg.eq.1)) then
            write(ifm,*)' '
            write(ifm,*)'APRES APPEL UMAT, STRESS='
            write(ifm,'(6(1X,E11.4))') (stress(i),i=1,ntens)
            write(ifm,*)'APRES APPEL UMAT, STATEV='
            write(ifm,'(10(1X,E11.4))')(statev(i),i=1,nstatv)
        endif
    endif
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dscal(3, rac2, stress(4), 1)
    endif
!
    if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then

           call r8inir(36, 0.d0, dsidep, 1)
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
           if ((niv.ge.2) .and. (idbg.eq.1)) then
               write(ifm,*)'APRES APPEL UMAT,OPERATEUR TANGENT DSIDEP='
               do i = 1, 6
                   write(ifm,'(6(1X,E11.4))') (dsidep(i,j),j=1,6)
               end do
           endif
     endif
!
    if (pnewdt .lt. 0.99d0) codret=1
    idbg=0
!
end subroutine
