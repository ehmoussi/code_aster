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

subroutine vplecs(eigsol, itemax_, maxitr_, nbborn_, nitv_,&
                  nborto_, nbvec2_, nbvect_, nbrss_, nfreq_,&
                  nperm_, alpha_, omecor_, freq1_, freq2_,&
                  precdc_, precsh_, prorto_, prsudg_, seuil_,&
                  tol_, toldyn_, tolsor_, appr_, arret_,&
                  method_, typevp_, matra_, matrb_, matrc_,&
                  modrig_, optiof_, stoper_, sturm_, typcal_, typeqz_,&
                  typres_, amor_, masse_, raide_, tabmod_,&
                  lc_, lkr_, lns_, lpg_, lqz_)
!
! ROUTINE UTILITAIRE LISANT UNE SD_EIGENSOLVER ET CREEANT QUELQUES VALEURS DE LOGICAL ET CHARACTER
! UTILES POUR LA SUITE D'UN CALCUL MODAL DE MODE_ITER_SIMULT.
! POUR LIRE UNE SEULE VALEUR UTILISER PLUTOT VPLECI.
! CF VPINIS, VPLECS, VPLECI, VPECRI.
! RQ. OPTIOF='PLUS_PETITE' + LPG=.TRUE. SIGNIFIE QUE LE CHAMPS STOCKE CONTIENT EN FAIT LA CHAINE
!     'PLUS_GRANDE'.
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! --- INPUT
!
    character(len=19), intent(in) :: eigsol
!
! --- OUTPUT
!
    integer, optional, intent(out) :: itemax_, maxitr_, nbborn_, nitv_, nborto_ 
    integer, optional, intent(out) :: nbvec2_, nbvect_, nbrss_, nfreq_, nperm_
    real(kind=8), optional, intent(out) :: alpha_, omecor_, freq1_, freq2_, precdc_
    real(kind=8), optional, intent(out) :: precsh_, prorto_, prsudg_
    real(kind=8), optional, intent(out) :: seuil_, tol_, toldyn_, tolsor_
    character(len=1), optional, intent(out) :: appr_
    character(len=8), optional, intent(out) :: arret_, method_
    character(len=9), optional, intent(out) :: typevp_
    character(len=14), optional, intent(out) :: matra_, matrb_, matrc_
    character(len=16), optional, intent(out) :: modrig_, optiof_, stoper_
    character(len=16), optional, intent(out) :: sturm_, typcal_, typeqz_, typres_
    character(len=19), optional, intent(out) :: amor_, masse_, raide_, tabmod_
    aster_logical, optional, intent(out) :: lc_, lkr_, lns_, lpg_, lqz_
!
! --- INPUT/OUTPUT
! None
!
! --- VARIABLES LOCALES
!
    integer :: eislvi, eislvk, eislvr, jrefa, indf
    real(kind=8) :: undf
    character(len=1) :: ktyp
    aster_logical :: lnsc, lnsk, lnsm
!
    integer :: itemax, maxitr, nbborn, nitv, nborto 
    integer :: nbvec2, nbvect, nbrss, nfreq, nperm
    real(kind=8) :: alpha, omecor, freq1, freq2, precdc
    real(kind=8) :: precsh, prorto, prsudg
    real(kind=8) :: seuil, tol, toldyn, tolsor
    character(len=1) :: appr
    character(len=8) :: arret, method
    character(len=9) :: typevp
    character(len=14) :: matra, matrb, matrc
    character(len=16) :: modrig, optiof, stoper
    character(len=16) :: sturm, typcal, typeqz, typres
    character(len=19) :: amor, masse, raide, tabmod
    aster_logical :: lc, lkr, lns, lpg, lqz
!
! --  BUFFERS DE LECTURE (EN CAS D'APPELS AVEC K*BID, PASSAGE PAR REFERENCE)
    character(len=1) :: app2
    character(len=8) :: arre2, metho2
    character(len=16) :: modri2, optio2, stope2, stur2, typeq2, typre2, typca2
    character(len=19) :: amo2, mass2, raid2, tabmo2
!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!
!
! --  INITS.
    call jemarq()
    indf=isnnem()
    undf=r8vide()
!
! --  OUVERTURE DE LA SD
    call jeveuo(eigsol//'.ESVK', 'L', eislvk)
    call jeveuo(eigsol//'.ESVI', 'L', eislvi)
    call jeveuo(eigsol//'.ESVR', 'L', eislvr)
!
! --  LECTURE PARAMETRES SOLVEURS MODAUX CHARACTER
    typre2=''
    typre2=trim(zk24(eislvk-1+1))
    raid2=''
    raid2 =trim(zk24(eislvk-1+2))
    mass2=''
    mass2 =trim(zk24(eislvk-1+3))
    amo2=''
    amo2  =trim(zk24(eislvk-1+4))
    optio2=''
    optio2=trim(zk24(eislvk-1+5))
    metho2=''
    metho2=trim(zk24(eislvk-1+6))
    modri2=''
    modri2=trim(zk24(eislvk-1+7))
    arre2=''
    arre2 =trim(zk24(eislvk-1+8))
    tabmo2=''
    tabmo2=trim(zk24(eislvk-1+9))
    stope2=''
    stope2=trim(zk24(eislvk-1+10))
    stur2=''
    stur2 =trim(zk24(eislvk-1+11))
    typca2=''
    typca2=trim(zk24(eislvk-1+12))
!
    app2=''
    app2  =trim(zk24(eislvk-1+16))
    typeq2=''
    select case (metho2)
    case('TRI_DIAG')
    case('JACOBI')
    case('SORENSEN')
    case('QZ')
        typeq2=trim(zk24(eislvk-1+17))
    case default
        ASSERT(.false.)
    end select
!
! --  LECTURE PARAMETRES SOLVEURS MODAUX ENTIERS
    nfreq =zi(eislvi-1+1)
    nbvect=zi(eislvi-1+2)
    nbvec2=zi(eislvi-1+3)
    nbrss =zi(eislvi-1+4)
    nbborn=zi(eislvi-1+5)
    nborto=indf
    nitv  =indf
    itemax=indf
    nperm =indf
    maxitr=indf
    select case (metho2)
    case('TRI_DIAG')
        nborto=zi(eislvi-1+11)
        nitv  =zi(eislvi-1+12)
    case('JACOBI')
        itemax=zi(eislvi-1+11)
        nperm =zi(eislvi-1+12)
    case('SORENSEN')
        maxitr=zi(eislvi-1+11)
    case('QZ')
    case default
        ASSERT(.false.)
    end select
!
! --  LECTURE PARAMETRES SOLVEURS MODAUX REELS
    freq1 =zr(eislvr-1+1)
    freq2 =zr(eislvr-1+2)
    precsh=zr(eislvr-1+3)
    omecor=zr(eislvr-1+4)
    precdc=zr(eislvr-1+5)
    seuil =zr(eislvr-1+6)
    prorto=undf
    prsudg=undf
    tol   =undf
    toldyn=undf
    tolsor=undf
    alpha =undf
    select case (metho2)
    case('TRI_DIAG')
        prorto=zr(eislvr-1+11)
        prsudg=zr(eislvr-1+12)
    case('JACOBI')
        tol   =zr(eislvr-1+11)
        toldyn=zr(eislvr-1+12)
    case('SORENSEN')
        tolsor=zr(eislvr-1+11)
        alpha =zr(eislvr-1+12)
    case('QZ')
    case default
        ASSERT(.false.)
    end select
!
! --  INIT. MATRA/B/C ET TYPEVP
    select case (typre2)
    case('DYNAMIQUE')
        matra ='MATR_RIGI'
        matrb ='MATR_MASS'
        matrc ='MATR_AMOR'
        typevp='FREQ'
    case('MODE_FLAMB')
        matra ='MATR_RIGI'
        matrb ='MATR_RIGI_GEOM'
        matrc =''
        typevp='CHAR_CRIT'
    case('GENERAL')
        matra ='MATR_A'
        matrb ='MATR_B'
        matrc ='MATR_C'
        typevp='CHAR_CRIT'
    case default
        ASSERT(.false.)
    end select
!
! --  INIT. LC
    if (amo2 .eq. '') then
        lc=.false.
    else
        lc=.true.
    endif
!
! --  INIT. LPG
    if (optio2(1:11) .eq. 'PLUS_GRANDE') then
        lpg=.true.
        optio2='PLUS_PETITE'
    else
        lpg=.false.
    endif
!
! --  INIT. LQZ
    if (metho2(1:2) .eq. 'QZ') then
        lqz=.true.
    else
        lqz=.false.
    endif
!
! --  INIT. LKR
!
    call jelira(raid2//'.VALM', 'TYPE', cval=ktyp)
    if (ktyp .eq. 'R') then
        lkr=.true.
    else if (ktyp.eq.'C') then
        lkr=.false.
    else
        ASSERT(.false.)
    endif
!
! --  INIT. LNS
    call jeveuo(raid2//'.REFA', 'L', jrefa)
    if (trim(zk24(jrefa-1+9)) .eq. 'MS') then
        lnsk=.false.
    else if (trim(zk24(jrefa-1+9)).eq.'MR') then
        lnsk=.true.
    else
        ASSERT(.false.)
    endif 
    call jeveuo(mass2//'.REFA', 'L', jrefa)
    if (trim(zk24(jrefa-1+9)) .eq. 'MS') then
        lnsm=.false.
    else if (trim(zk24(jrefa-1+9)).eq.'MR') then
        lnsm=.true.
    else
        ASSERT(.false.)
    endif
    if (lc) then
        call jeveuo(amo2//'.REFA', 'L', jrefa)
        if (trim(zk24(jrefa-1+9)) .eq. 'MS') then
            lnsc=.false.
        else if (trim(zk24(jrefa-1+9)).eq.'MR') then
            lnsc=.true.
        else
            ASSERT(.false.)
        endif
    else
        lnsc=.false.
    endif
    if (lnsk .or. lnsm .or. lnsc) then
        lns=.true.
    else
        lns=.false.
    endif
!
! --  CHARGEMENT DES VALEURS OUTPUTS CHARACTER
    appr=trim(app2)
    arret=trim(arre2)
    method=trim(metho2)
    modrig=trim(modri2)
    optiof=trim(optio2)
    stoper=trim(stope2)
    sturm=trim(stur2)
    typcal=trim(typca2)
    typeqz=trim(typeq2)
    typres=trim(typre2)
    amor=trim(amo2)
    masse=trim(mass2)
    raide=trim(raid2)
    tabmod=trim(tabmo2)
!
! -- GESTION DES ARGUMENTS DE SORTIE
    if (present(itemax_))itemax_ = itemax
    if (present(maxitr_))maxitr_ = maxitr
    if (present(nbborn_))nbborn_ = nbborn
    if (present(nitv_))nitv_ = nitv
    if (present(nborto_))nborto_ = nborto
    if (present(nbvec2_))nbvec2_ = nbvec2
    if (present(nbvect_))nbvect_ = nbvect
    if (present(nbrss_))nbrss_ = nbrss
    if (present(nfreq_))nfreq_ = nfreq
    if (present(nperm_))nperm_ = nperm
    if (present(alpha_))alpha_ = alpha
    if (present(omecor_))omecor_ = omecor
    if (present(freq1_))freq1_ = freq1
    if (present(freq2_))freq2_ = freq2
    if (present(precdc_))precdc_ = precdc
    if (present(precsh_))precsh_ = precsh
    if (present(prorto_))prorto_ = prorto
    if (present(prsudg_))prsudg_ = prsudg
    if (present(seuil_))seuil_ = seuil
    if (present(tol_))tol_ = tol
    if (present(toldyn_))toldyn_ = toldyn
    if (present(tolsor_))tolsor_ = tolsor
    if (present(appr_))appr_ = appr
    if (present(arret_))arret_ = arret
    if (present(method_))method_ = method
    if (present(typevp_))typevp_ = typevp
    if (present(matra_))matra_ = matra
    if (present(matrb_))matrb_ = matrb
    if (present(matrc_))matrc_ = matrc
    if (present(modrig_))modrig_ = modrig
    if (present(optiof_))optiof_ = optiof
    if (present(stoper_))stoper_ = stoper
    if (present(sturm_))sturm_ = sturm
    if (present(typcal_))typcal_ = typcal
    if (present(typeqz_))typeqz_ = typeqz
    if (present(typres_))typres_ = typres
    if (present(amor_))amor_ = amor
    if (present(masse_))masse_ = masse
    if (present(raide_))raide_ = raide
    if (present(tabmod_))tabmod_ = tabmod
    if (present(lc_))lc_ = lc
    if (present(lkr_))lkr_ = lkr
    if (present(lns_))lns_ = lns
    if (present(lpg_))lpg_ = lpg
    if (present(lqz_))lqz_ = lqz
!
    call jedema()
!
!     FIN DE VPLECS
!
end subroutine
