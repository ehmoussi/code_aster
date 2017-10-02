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

subroutine nmflam(option, modele, numedd, numfix     , carele,&
                  ds_constitutive, numins, mate       , comref,&
                  lischa, ds_contact, ds_algopara, fonact,&
                  ds_measure, sddisc, sddyna,&
                  sdpost, valinc, solalg, meelem     , measse,&
                  veelem, sderro)
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
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmecsd.h"
#include "asterfort/nmflal.h"
#include "asterfort/nmflin.h"
#include "asterfort/nmflma.h"
#include "asterfort/nmlesd.h"
#include "asterfort/nmop45.h"
#include "asterfort/omega2.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/vpcres.h"
!
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
    integer :: numins, fonact(*)
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    type(NL_DS_Contact), intent(in) :: ds_contact
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_Constitutive), intent(in) :: ds_constitutive
    character(len=16) :: option
    character(len=19) :: lischa, sddisc, sddyna, sdpost, meelem(*)
    character(len=19) :: veelem(*), measse(*), solalg(*), valinc(*)
    character(len=24) :: mate, comref, sderro
    character(len=24) :: modele, numedd, numfix, carele
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DE MODES
!
! --------------------------------------------------------------------------------------------------
!
! IN  OPTION : TYPE DE CALCUL
!              'FLAMBSTA' MODES DE FLAMBEMENT EN STATIQUE
!              'FLAMBDYN' MODES DE FLAMBEMENT EN DYNAMIQUE
!              'VIBRDYNA' MODES VIBRATOIRES
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  MATE   : CHAMP MATERIAU
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  COMREF : VARI_COM DE REFERENCE
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! In  ds_algopara      : datastructure for algorithm parameters
! IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  NUMINS : NUMERO D'INSTANT
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  MEELEM : MATRICES ELEMENTAIRES (POUR NMFLMA)
! IN  MEASSE : MATRICE ASSEMBLEE (POUR NMFLMA)
! IN  VEELEM : VECTEUR ELEMENTAIRE (POUR NMFLMA)
! IN  SDERRO : SD ERREUR
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: linsta
    integer :: nfreq, nfreqc, nbrss, maxitr, nbborn, i, ljeveu, ibid, iret
    integer :: defo, ldccvg, numord, nddle, nsta, ljeve2, cdsp, nbvec2, nbvect
    real(kind=8) :: bande(2), r8bid, alpha, tolsor, precsh, fcorig, precdc, omecor, freqm, freqv
    real(kind=8) :: freqa, freqr, csta
    character(len=1)  :: k1bid
    character(len=4)  :: mod45
    character(len=8)  :: sdmode, sdstab, method, k8bid
    character(len=16) :: optmod, varacc, typmat, modrig, typres, k16bid, optiof
    character(len=19) :: matgeo, matas2, vecmod, champ, k19bid, champ2, vecmo2, eigsol
    character(len=19) :: raide, masse
    character(len=24) :: k24bid, ddlexc, ddlsta
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    matgeo = '&&NMFLAM.MAGEOM'
    matas2 = '&&NMFLAM.MATASS'
    linsta = .false.
!
! --- NOM DE LA SD DE STOCKAGE DES MODES
!
    sdmode = '&&NM45BI'
    sdstab = '&&NM45SI'
!
! --- RECUPERATION DES OPTIONS
!
    call nmflal(option, ds_constitutive, sdpost, mod45 , defo  ,&
                nfreq , cdsp           , typmat, optmod, bande ,&
                nddle , ddlexc         , nsta  , ddlsta, modrig)
!
! --- CALCUL DE LA MATRICE TANGENTE ASSEMBLEE ET DE LA MATRICE GEOM.
!
    call nmflma(typmat, mod45 , defo  , ds_algopara, modele,&
                mate  , carele, sddisc, sddyna     , fonact,&
                numins, valinc, solalg, lischa     , comref,&
                ds_contact, numedd     , numfix,&
                ds_constitutive, ds_measure, meelem,&
                measse, veelem, nddle , ddlexc     , modrig,&
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
    k1bid=''
    k8bid=''
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
! VERI_MODE/PREC_SHIFT EN DUR
    precdc = 5.d-2
    if (typres(1:9) .eq. 'DYNAMIQUE') omecor = omega2(fcorig)
    if (option(1:5).eq.'BANDE') then
      nbborn=2
    else
      nbborn=1
    endif
    call vpcres(eigsol, typres, raide, masse, k19bid, optiof, method, k16bid, k8bid, k19bid,&
                k16bid, k16bid, k1bid, k16bid, nfreqc, nbvect, nbvec2, nbrss, nbborn, ibid,&
                ibid, ibid, ibid, maxitr, bande, precsh, omecor, precdc, r8bid,&
                r8bid, r8bid, r8bid, r8bid, tolsor, alpha)
!
! --- CALCUL MODAL PROPREMENT DIT
!
    call nmop45(eigsol, defo, mod45, ddlexc, nddle, sdmode, sdstab, ddlsta, nsta)
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
        ASSERT(.false.)
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
            ASSERT(.false.)
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
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_VIBR', ibid, r8bid,&
                    vecmod)
    else if (mod45 .eq. 'FLAM') then
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_FLAM', ibid, r8bid,&
                    vecmod)
        if (nsta .ne. 0) then
            call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_STAB', ibid, r8bid,&
                        vecmo2)
        endif
    else
        ASSERT(.false.)
    endif
!
! --- RECUPERATION DES MODES DANS LA SD MODE
!
    call rsexch('F', sdmode, 'DEPL', numord, champ,&
                iret)
    call copisd('CHAMP_GD', 'V', champ, vecmod)
    if (nsta .ne. 0) then
        call rsexch('F', sdstab, 'DEPL', 1, champ2,&
                    iret)
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
        ASSERT(.false.)
    endif
!
! --- DETECTION INSTABILITE SI DEMANDE
!
    if (mod45 .eq. 'FLAM') then
        call nmflin(sdpost, matas2, freqr, linsta)
        call nmcrel(sderro, 'CRIT_STAB', linsta)
    endif
!
! --- ARRET
!
999 continue
!
! --- MODE SELECTIONNE ECRIT DANS SDPOST
!
    if (mod45 .eq. 'VIBR') then
        call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_VIBR', ibid, freqr,&
                    k24bid)
        call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_VIBR', numord, r8bid,&
                    k24bid)
    else if (mod45 .eq. 'FLAM') then
        call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_FLAM', ibid, freqr,&
                    k24bid)
        call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_FLAM', numord, r8bid,&
                    k24bid)
        if (nsta .ne. 0) then
            call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_STAB', ibid, csta,&
                        k24bid)
            call nmecsd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_STAB', 1, r8bid,&
                        k24bid)
        endif
    else
        ASSERT(.false.)
    endif
!
! --- DESTRUCTION DE LA SD DE STOCKAGE DES MODES
!
    call jedetc('G', sdmode, 1)
    call jedetc('G', sdstab, 1)
!
    call jedema()
end subroutine
