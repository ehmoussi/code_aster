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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
subroutine nmflam(option         ,&
                  model          , mate         , cara_elem , list_load  , list_func_acti,&
                  nume_dof       , nume_dof_inva,&
                  ds_constitutive, varc_refe    ,&
                  sddisc         , nume_inst    ,& 
                  sddyna         , sderro       , ds_contact, ds_algopara,& 
                  ds_measure     ,&
                  hval_incr      , hval_algo    ,&
                  hval_meelem    , hval_measse  ,&
                  hval_veelem    ,&
                  ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8maem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/freqom.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmflal.h"
#include "asterfort/nmflin.h"
#include "asterfort/nmflma.h"
#include "asterfort/nmop45.h"
#include "asterfort/omega2.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/vpcres.h"
#include "asterfort/vpleci.h"
!
character(len=16), intent(in) :: option
character(len=24), intent(in) :: model, mate, cara_elem
character(len=19), intent(in) :: list_load
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: nume_dof, nume_dof_inva
character(len=24), intent(in) :: varc_refe
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
character(len=19), intent(in) :: sddyna
character(len=24), intent(in) :: sderro
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_meelem(*), hval_measse(*)
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Initializations
!
! Spectral analysis (MODE_VIBR/CRIT_STAB)
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : which compute (FLAMBSTA/FLAMBDYN/VIBRDYNA)
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  list_load        : datastructure for list of loads
! In  list_func_acti   : list of active functionnalities
! In  nume_dof         : name of numbering (NUME_DDL)
! In  nume_dof_inva    : name of reference numbering (invariant)
! In  ds_constitutive  : datastructure for constitutive laws management
! In  varc_refe        : name of reference external state variables
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  sddyna           : datastructure for dynamic
! In  sderro           : datastructure for error management (events)
! In  ds_contact       : datastructure for contact management
! In  ds_algopara      : datastructure for algorithm parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_meelem      : hat-variable for elementary matrix
! In  hval_measse      : hat-variable for matrix
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: linsta
    integer :: nfreq, nfreqc, nbrss, maxitr, i, ljeveu, ibid, iret, nbborn
    integer :: defo, ldccvg, numord, nddle, nsta, ljeve2, cdsp, nbvec2, nbvect
    real(kind=8) :: bande(2), r8bid, alpha, tolsor, precsh, fcorig, precdc, omecor, freqm, freqv
    real(kind=8) :: freqa, freqr, csta
    character(len=1)  :: k1bid
    character(len=4)  :: mod45
    character(len=8)  :: sdmode, sdstab, method, arret
    character(len=16) :: optmod, varacc, typmat, modrig, typres, k16bid, optiof, sturm, modri2
    character(len=16) :: stoper
    character(len=19) :: matgeo, matas2, vecmod, champ, k19bid, champ2, vecmo2, eigsol
    character(len=19) :: raide, masse
    character(len=24) :: k24bid
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    matgeo = '&&NMFLAM.MAGEOM'
    matas2 = '&&NMFLAM.MATASS'
    linsta = ASTER_FALSE
!
! --- NOM DE LA SD DE STOCKAGE DES MODES
!
    sdmode = '&&NM45BI'
    sdstab = '&&NM45SI'
!
! --- RECUPERATION DES OPTIONS
!
    call nmflal(option, ds_constitutive, ds_posttimestep, mod45 , defo  ,&
                nfreq , cdsp           , typmat         , optmod, bande ,&
                nddle , nsta           , modrig)
!
! --- CALCUL DE LA MATRICE TANGENTE ASSEMBLEE ET DE LA MATRICE GEOM.
!
    call nmflma(typmat, mod45 , defo  , ds_algopara, model,&
                mate  , cara_elem, sddisc, sddyna     , list_func_acti,&
                nume_inst, hval_incr, hval_algo, list_load     , varc_refe,&
                ds_contact, nume_dof     , nume_dof_inva,&
                ds_constitutive, ds_measure, hval_meelem,&
                hval_measse, hval_veelem, nddle , ds_posttimestep, modrig,&
                ldccvg, matas2, matgeo)
    ASSERT(ldccvg.eq.0)
!
! --- CALCUL DES MODES PROPRES
!
!  ON DIFFERENCIE NFREQ (DONNEE UTILISATEUR) DE NFREQC
!  QUI EST LE NB DE FREQ TROUVEES PAR L'ALGO DANS NMOP45
!
    nfreqc = nfreq
    
!
! --- CREATION DE LA SD EIGENSOLVER PARAMETRANT LE CALCUL MODAL
! --- UN GEP SYM REEL RESOLU VIA SORENSEN
!
    eigsol='&&NMFLAM.EIGSOL'
    k1bid='R'
    k16bid=''
    k19bid=''
    ibid=isnnem()
    r8bid=r8vide()
    if (mod45 .eq. 'VIBR') then
        typres = 'DYNAMIQUE'
    else
        typres = 'MODE_FLAMB'
    endif
    method = 'SORENSEN'
! MATR_A
    raide=matas2
! MATR_B
    masse=matgeo
! OPTION MODALE
    optiof=optmod
    if (optiof(1:5).eq.'BANDE') then
      nbborn=2
    else
      nbborn=1
    endif
! DIM_SOUS_ESPACE EN DUR
    nbvect=0
! COEF_SOUS_ESPACE
    nbvec2=cdsp
! NMAX_ITER_SHIFT EN DUR
    nbrss = 5
! PARA_ORTHO_SOREN EN DUR
    alpha = 0.717d0
! NMAX_ITER_SOREN EN DUR
    maxitr = 200
! PREC_SOREN EN DUR
    tolsor = 0.d0
! CALC_FREQ/FLAMB/PREC_SHIFT EN DUR
    precsh = 5.d-2
! SEUIL_FREQ/CRIT EN DUR
    fcorig = 1.d-2
    if (typres(1:9) .eq. 'DYNAMIQUE') then
      omecor = omega2(fcorig)
      bande(1)=freqom(bande(1))
      bande(2)=freqom(bande(2))
    else
      omecor=fcorig
    endif
! VERI_MODE/PREC_SHIFT EN DUR
    precdc = 5.d-2
! STOP_BANDE_VIDE EN DUR
    arret='NON'
! STURM EN DUR
    sturm='NON'
! OPTION MODE RIGIDE EN DUR
    modri2='SANS'
! OPTION STOP_ERREUR EN DUR
    stoper='NON'
    call vpcres(eigsol, typres, raide, masse, k19bid, optiof, method, modri2, arret, k19bid,&
                stoper, sturm, k1bid, k16bid, nfreqc, nbvect, nbvec2, nbrss, nbborn, ibid,&
                ibid, ibid, ibid, maxitr, bande, precsh, omecor, precdc, r8bid,&
                r8bid, r8bid, r8bid, r8bid, tolsor, alpha)
!
! --- CALCUL MODAL PROPREMENT DIT
!
    call nmop45(eigsol, defo, mod45, sdmode, sdstab, ds_posttimestep)
    
    call vpleci(eigsol, 'I', 1, k24bid, r8bid, nfreqc)
    call detrsd('EIGENSOLVER',eigsol)

    if (nfreqc .eq. 0) then
        freqr = r8vide()
        numord = -1
        goto 999
    endif
!
! --- SELECTION DU MODE DE PLUS PETITE FREQUENCE
!
    if (mod45 .eq. 'VIBR') then
        varacc = 'FREQ'
    else if (mod45 .eq. 'FLAM') then
        varacc = 'CHAR_CRIT'
    else
        ASSERT(ASTER_FALSE)
    endif
    freqm = r8maem()
    numord = 0
    do i = 1, nfreqc
        call rsadpa(sdmode, 'L', 1, varacc, i,&
                    0, sjv=ljeveu)
        freqv = zr(ljeveu)
        freqa = abs(freqv)
        if (freqa .lt. freqm) then
            numord = i
            freqm = freqa
            freqr = freqv
        endif
        if (mod45 .eq. 'VIBR') then
            call utmess('I', 'MECANONLINE6_10', si=i, sr=freqv)
        else if (mod45 .eq. 'FLAM') then
            call utmess('I', 'MECANONLINE6_11', si=i, sr=freqv)
        else
            ASSERT(ASTER_FALSE)
        endif
    end do
    if (nsta .ne. 0) then
        call rsadpa(sdstab, 'L', 1, 'CHAR_STAB', 1,&
                    0, sjv=ljeve2)
        csta = zr(ljeve2)
        call utmess('I', 'MECANONLINE6_12', si=1, sr=csta)
    endif
!
! --- NOM DU MODE
!
    if (mod45 .eq. 'VIBR') then
        vecmod = ds_posttimestep%mode_vibr_resu%eigen_vector
    else if (mod45 .eq. 'FLAM') then
        vecmod = ds_posttimestep%mode_flam_resu%eigen_vector
        if (nsta .ne. 0) then
            vecmo2 = ds_posttimestep%crit_stab_resu%eigen_vector
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- RECUPERATION DES MODES DANS LA SD MODE
!
    call rsexch('F', sdmode, 'DEPL', numord, champ, iret)
    call copisd('CHAMP_GD', 'V', champ, vecmod)
    if (nsta .ne. 0) then
        call rsexch('F', sdstab, 'DEPL', 1, champ2, iret)
        call copisd('CHAMP_GD', 'V', champ2, vecmo2)
    endif
!
! --- AFFICHAGE DES MODES
!
    if (mod45 .eq. 'VIBR') then
        call utmess('I', 'MECANONLINE6_14', sr=freqr)
    else if (mod45 .eq. 'FLAM') then
        call utmess('I', 'MECANONLINE6_15', sr=freqr)
        if (nsta .ne. 0) then
            call utmess('I', 'MECANONLINE6_16', sr=csta)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- DETECTION INSTABILITE SI DEMANDE
!
    if (mod45 .eq. 'FLAM') then
        call nmflin(ds_posttimestep, matas2, freqr, linsta)
        call nmcrel(sderro, 'CRIT_STAB', linsta)
    endif
!
! --- ARRET
!
999 continue
!
! - Save results
!
    if (mod45 .eq. 'VIBR') then
        ds_posttimestep%mode_vibr_resu%eigen_value = freqr
        ds_posttimestep%mode_vibr_resu%eigen_index = numord
    else if (mod45 .eq. 'FLAM') then
        ds_posttimestep%mode_flam_resu%eigen_value = freqr
        ds_posttimestep%mode_flam_resu%eigen_index = numord
        if (nsta .ne. 0) then
            ds_posttimestep%crit_stab_resu%eigen_value = csta
            ds_posttimestep%crit_stab_resu%eigen_index = 1
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- DESTRUCTION DE LA SD DE STOCKAGE DES MODES
!
    call jedetc('G', sdmode, 1)
    call jedetc('G', sdstab, 1)
!
    call jedema()
end subroutine
