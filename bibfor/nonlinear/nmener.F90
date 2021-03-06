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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmener(valinc, veasse, measse, sddyna, eta        ,&
                  ds_energy, fonact, numedd, numfix,&
                  meelem, numins, modele, ds_material, carele   ,&
                  ds_constitutive, ds_measure, sddisc, solalg,&
                  ds_contact, ds_system)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/enerca.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchai.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmfini.h"
#include "asterfort/nmmass.h"
#include "asterfort/wkvect.h"
!
character(len=19) :: sddyna, valinc(*), veasse(*), measse(*)
type(NL_DS_Energy), intent(inout) :: ds_energy
type(NL_DS_Material), intent(in) :: ds_material
character(len=19) :: meelem(*), sddisc, solalg(*)
character(len=24) :: numedd, numfix, modele, carele
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_System), intent(in) :: ds_system
type(NL_DS_Measure), intent(inout) :: ds_measure
real(kind=8) :: eta
integer :: fonact(*), numins
type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CALCUL DES ENERGIES
!
! --------------------------------------------------------------------------------------------------
!
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
! IN  SDDYNA : SD DYNAMIQUE
! IN  ETA    : COEFFICIENT DU PILOTAGE
! IO  ds_energy        : datastructure for energy management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  NUMEDD : NUME_DDL
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  MEELEM : MATRICES ELEMENTAIRES
! IN  NUMINS : NUMERO D'INSTANT
! IN  MODELE : MODELE
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_system        : datastructure for non-linear system management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter:: zveass = 19
    integer :: iret(zveass)
    character(len=19) :: depmoi, depplu, vitmoi, vitplu, masse, amort, rigid
    character(len=19) :: fexmoi, fexplu, fammoi, fnomoi
    character(len=19) :: famplu, flimoi, fliplu, fnoplu
    character(len=19) :: lisbid
    character(len=8) :: k8bid
    integer :: ivitmo, ivitpl
    integer :: neq, i, long, j
    integer :: ifexte, ifamor, ifliai, ifcine, ifnoda
    aster_logical :: ldyna, lamor, lexpl, reassm
    real(kind=8), pointer :: epmo(:) => null()
    real(kind=8), pointer :: eppl(:) => null()
    real(kind=8), pointer :: fammo(:) => null()
    real(kind=8), pointer :: fampl(:) => null()
    real(kind=8), pointer :: fexmo(:) => null()
    real(kind=8), pointer :: fexpl(:) => null()
    real(kind=8), pointer :: flimo(:) => null()
    real(kind=8), pointer :: flipl(:) => null()
    real(kind=8), pointer :: fnomo(:) => null()
    real(kind=8), pointer :: fnopl(:) => null()
    real(kind=8), pointer :: veass(:) => null()
    real(kind=8), pointer :: v_fvarc_curr(:) => null()
    real(kind=8), pointer :: v_cnctdf(:) => null()
    real(kind=8), pointer :: v_cnctdc(:) => null()
    real(kind=8), pointer :: v_cnunil(:) => null()
    real(kind=8), pointer :: v_cneltc(:) => null()
    real(kind=8), pointer :: v_cneltf(:) => null()
    real(kind=8), pointer :: v_cnfint(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    call nmchai('VEASSE', 'LONMAX', long)
    ASSERT(long.eq.zveass)
!
    k8bid=' '
    reassm=.false.
    call nmchex(valinc, 'VALINC', 'DEPMOI', depmoi)
    call jeveuo(depmoi//'.VALE', 'L', vr=epmo)
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call jeveuo(depplu//'.VALE', 'L', vr=eppl)
    call jelira(depmoi//'.VALE', 'LONMAX', ival=neq)
    ldyna=ndynlo(sddyna,'DYNAMIQUE')
    lamor=ndynlo(sddyna,'MAT_AMORT')
    lexpl=ndynlo(sddyna,'EXPLICITE')
    if (ldyna) then
        call nmchex(valinc, 'VALINC', 'VITMOI', vitmoi)
        call jeveuo(vitmoi//'.VALE', 'L', ivitmo)
        call nmchex(valinc, 'VALINC', 'VITPLU', vitplu)
        call jeveuo(vitplu//'.VALE', 'L', ivitpl)
    else
        ivitmo=1
        ivitpl=1
    endif
    call nmchex(valinc, 'VALINC', 'FEXMOI', fexmoi)
    call nmchex(valinc, 'VALINC', 'FEXPLU', fexplu)
    call nmchex(valinc, 'VALINC', 'FAMMOI', fammoi)
    call nmchex(valinc, 'VALINC', 'FNOMOI', fnomoi)
    call nmchex(valinc, 'VALINC', 'FAMPLU', famplu)
    call nmchex(valinc, 'VALINC', 'FLIMOI', flimoi)
    call nmchex(valinc, 'VALINC', 'FLIPLU', fliplu)
    call nmchex(valinc, 'VALINC', 'FNOPLU', fnoplu)
    call nmchex(measse, 'MEASSE', 'MERIGI', rigid)
    call nmchex(measse, 'MEASSE', 'MEMASS', masse)
    call nmchex(measse, 'MEASSE', 'MEAMOR', amort)
    call jeveuo(ds_material%fvarc_curr(1:19)//'.VALE', 'L', vr=v_fvarc_curr)
    if (ds_contact%l_cnctdf) then
        call jeveuo(ds_contact%cnctdf(1:19)//'.VALE', 'L', vr=v_cnctdf)
    endif
    if (ds_contact%l_cnctdc) then
        call jeveuo(ds_contact%cnctdc(1:19)//'.VALE', 'L', vr=v_cnctdc)
    endif
    if (ds_contact%l_cnunil) then
        call jeveuo(ds_contact%cnunil(1:19)//'.VALE', 'L', vr=v_cnunil)
    endif
    if (ds_contact%l_cneltc) then
        call jeveuo(ds_contact%cneltc(1:19)//'.VALE', 'L', vr=v_cneltc)
    endif
    if (ds_contact%l_cneltf) then
        call jeveuo(ds_contact%cneltf(1:19)//'.VALE', 'L', vr=v_cneltf)
    endif
    call jeveuo(ds_system%cnfint(1:19)//'.VALE', 'L', vr=v_cnfint)
!
!
    do i = 1, zveass
        iret(i)=0
        call jeexin(veasse(i)//'.VALE', iret(i))
    end do
!
    call jeveuo(fexmoi//'.VALE', 'L', vr=fexmo)
    call jeveuo(fammoi//'.VALE', 'L', vr=fammo)
    call jeveuo(flimoi//'.VALE', 'L', vr=flimo)
    call jeveuo(fnomoi//'.VALE', 'L', vr=fnomo)
    call jeveuo(fexplu//'.VALE', 'E', vr=fexpl)
    call jeveuo(famplu//'.VALE', 'E', vr=fampl)
    call jeveuo(fliplu//'.VALE', 'E', vr=flipl)
    call jeveuo(fnoplu//'.VALE', 'E', vr=fnopl)
!
    fexpl(:) = 0.d0
    fampl(:) = 0.d0
    flipl(:) = 0.d0
    fnopl(:) = 0.d0
!
    call wkvect('FEXTE', 'V V R', 2*neq, ifexte)
    call wkvect('FAMOR', 'V V R', 2*neq, ifamor)
    call wkvect('FLIAI', 'V V R', 2*neq, ifliai)
    call wkvect('FNODA', 'V V R', 2*neq, ifnoda)
    call wkvect('FCINE', 'V V R', neq, ifcine)
!
! - Add external state variable contribution
!
    fexpl(:) = fexpl(:)+v_fvarc_curr(:)
    fnopl(:) = fnopl(:)+v_fvarc_curr(:)
!
! - Add discrete contact/friction contribution
!
    if (ds_contact%l_cnctdf) then
        flipl(:) = flipl(:) + v_cnctdf(:)
    endif
    if (ds_contact%l_cnctdc) then
        flipl(:) = flipl(:) + v_cnctdc(:)
    endif
    if (ds_contact%l_cnunil) then
        flipl(:) = flipl(:) + v_cnunil(:)
    endif
!
! - Add continue contact/friction contribution
!
    if (ds_contact%l_cneltc) then
        flipl(:) = flipl(:) + v_cneltc(:)
        fnopl(:) = fnopl(:) - v_cneltc(:)
    endif
    if (ds_contact%l_cneltf) then
        flipl(:) = flipl(:) + v_cneltf(:)
        fnopl(:) = fnopl(:) - v_cneltf(:)
    endif
!
! - Add other contributions
!
    do i = 1, zveass
        if (iret(i) .ne. 0) then
            call jeveuo(veasse(i)//'.VALE', 'L', vr=veass)
! --------------------------------------------------------------------
! 5  - CNFEDO : CHARGES MECANIQUES FIXES DONNEES
! 7  - CNLAPL : FORCES DE LAPLACE
! 9  - CNFSDO : FORCES SUIVEUSES
! 12 - CNSSTF : FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION
! --------------------------------------------------------------------
            if ((i.eq.5) .or. (i.eq.7) .or. (i.eq.9) .or. (i.eq.12)) then
                fexpl(:)=fexpl(:)+veass(:)
! --------------------------------------------------------------------
! 6  - CNFEPI : FORCES PILOTEES PARAMETRE ETA A PRENDRE EN COMPTE
! --------------------------------------------------------------------
            else if (i.eq.6) then
                fexpl(:)=fexpl(:)+eta*veass(:)
! --------------------------------------------------------------------
! 1  - CNDIRI : BtLAMBDA                : IL FAUT PRENDRE L OPPOSE
! 8  - CNONDP : CHARGEMENT ONDES PLANES : IL FAUT PRENDRE L OPPOSE
! --------------------------------------------------------------------
            else if ((i.eq.1).or.(i.eq.8)) then
                fexpl(:)=fexpl(:)-veass(:)
! --------------------------------------------------------------------
! 17 - CNAMOD : FORCE D AMORTISSEMENT MODAL
! --------------------------------------------------------------------
            else if (i.eq.17) then
                fampl(:)=fampl(:)+veass(:)
! --------------------------------------------------------------------
! 10 - CNIMPE : FORCES IMPEDANCE
! --------------------------------------------------------------------
            else if (i.eq.10) then
                flipl(:)=flipl(:)+veass(:)
! --------------------------------------------------------------------
! 19 - CNVISS : CHARGEMENT VEC_ISS (FORCE_SOL)
! --------------------------------------------------------------------
            else if (i.eq.19) then
! CHARGEMENT FORCE_SOL CNVISS. SI ON COMPTE SA CONTRIBUTION EN TANT
! QUE FORCE DISSIPATIVE DE LIAISON, ON DOIT PRENDRE L OPPOSE.
                flipl(:)=flipl(:)-veass(:)
! --------------------------------------------------------------------
! 14 - CNCINE : INCREMENTS DE DEPLACEMENT IMPOSES (AFFE_CHAR_CINE)
! --------------------------------------------------------------------
            else if (i.eq.14) then
! ON DOIT RECONSTRUIRE LA MATRICE DE MASSE CAR ELLE A ETE MODIFIEE
! POUR SUPPRIMER DES DEGRES DE LIBERTE EN RAISON DE AFFE_CHAR_CINE.
                reassm=.true.
                do j = 1, neq
                    zr(ifcine-1+j)=zr(ifcine-1+j)+veass(j)
                end do
            endif
        endif
    end do
!
! - Add internal forces
!
    fnopl(:) = fnopl(:) + v_cnfint(:)
!
    if (reassm) then
! --- REASSEMBLAGE DE LA MATRICE DE MASSE.
        lisbid=' '
        call nmmass(lisbid, sddyna, numedd,&
                    numfix, meelem, masse)
    endif
!
! --- INITIALISATION DE LA FORCE EXTERIEURE ET DES FORCES INTERNES
! --- AU PREMIER PAS DE TEMPS.
! --- ON LE FAIT ICI AFIN DE DISPOSER D UNE MATRICE D AMORTISSEMENT.
!
    if (numins .eq. 1) then
        call nmfini(sddyna, valinc         , measse   , modele    , ds_material,&
                    carele, ds_constitutive, ds_system, ds_measure, sddisc     , numins,&
                    solalg, numedd         , fonact   )
    endif
!
! --- PREPARATION DES CHAMPS DE FORCE
!
    do i = 1, neq
        zr(ifexte-1+i+neq)=fexpl(i)
        zr(ifexte-1+i)=fexmo(i)
        zr(ifliai-1+i+neq)=flipl(i)
        zr(ifliai-1+i)=flimo(i)
        zr(ifamor-1+i+neq)=fampl(i)
        zr(ifamor-1+i)=fammo(i)
        zr(ifnoda-1+i+neq)=fnopl(i)
        zr(ifnoda-1+i)=fnomo(i)
    end do
!
    call enerca(valinc, epmo, zr(ivitmo), eppl, zr(ivitpl),&
                masse, amort, rigid, zr(ifexte), zr(ifamor),&
                zr(ifliai), zr(ifnoda), zr(ifcine), lamor, ldyna,&
                lexpl, ds_energy, k8bid)
!
!     ON NE PEUT PAS UTILISER NMFPAS POUR METTRE LES CHAMPS PLUS
!     EN CHAMP MOINS, SINON CA POSE PROBLEME EN LECTURE D'ETAT INITIAL
!     SI POURSUITE.
!     ON FAIT DONC LE REPORT DE CHAMP ICI
!
    call copisd('CHAMP_GD', 'V', fexplu, fexmoi)
    call copisd('CHAMP_GD', 'V', famplu, fammoi)
    call copisd('CHAMP_GD', 'V', fliplu, flimoi)
    call copisd('CHAMP_GD', 'V', fnoplu, fnomoi)
!
    call jedetr('FEXTE')
    call jedetr('FAMOR')
    call jedetr('FLIAI')
    call jedetr('FNODA')
    call jedetr('FCINE')
!
    call jedema()
!
end subroutine
