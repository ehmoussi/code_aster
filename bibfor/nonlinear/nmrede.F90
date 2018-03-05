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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmrede(sdnume, fonact, sddyna, matass, ds_material,&
                  veasse, neq, foiner, cnfext, cnfint,&
                  vchar, ichar)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
!
character(len=19) :: sddyna, sdnume
type(NL_DS_Material), intent(in) :: ds_material
character(len=19) :: veasse(*)
character(len=19) :: matass
integer :: fonact(*)
real(kind=8) :: vchar
integer :: ichar
integer :: neq
character(len=19) :: foiner, cnfext, cnfint
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE - RESIDU)
!
! MAXIMUM DU CHARGEMENT EXTERIEUR
!
! ----------------------------------------------------------------------
!
! IN  NUMEDD : NUMEROTATION NUME_DDL
! In  ds_material      : datastructure for material parameters
! IN  SDNUME : NOM DE LA SD NUMEROTATION
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  MATASS : MATRICE DU PREMIER MEMBRE ASSEMBLEE
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  SDDYNA : SD DYNAMIQUE
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  FOINER : VECT_ASSE DES FORCES D'INERTIE
! IN  CNFEXT : VECT_ASSE DES FORCES EXTERIEURES APPLIQUEES (NEUMANN)
! IN  CNFINT : VECT_ASSE DES FORCES INTERIEURES
! OUT VCHAR  : CHARGEMENT EXTERIEUR MAXI
! OUT ICHAR  : DDL OU LE CHARGEMENT EXTERIEUR EST MAXI
!
!
!
!
    integer :: jccid
    integer :: ifm, niv
    aster_logical :: ldyna, lcine, l_cont_cont, l_cont_lac
    character(len=19) :: cndiri
    integer :: ieq
    real(kind=8) :: val2, val3, appui, fext
    character(len=24) :: sdnuco
    integer :: jnuco
    real(kind=8), pointer :: diri(:) => null()
    real(kind=8), pointer :: vfext(:) => null()
    real(kind=8), pointer :: fint(:) => null()
    real(kind=8), pointer :: iner(:) => null()
    real(kind=8), pointer :: v_fvarc_curr(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- INITIALISATIONS
!
    vchar = 0.d0
    ichar = 0
    jccid = 0
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    lcine = isfonc(fonact,'DIRI_CINE')
    l_cont_cont = isfonc(fonact,'CONT_CONTINU')
    l_cont_lac  = isfonc(fonact,'CONT_LAC')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
!
! --- ACCES DDLS IMPOSES PAR AFFE_CHAR_CINE :
!
    if (lcine) then
        call jeveuo(matass(1:19)//'.CCID', 'L', jccid)
    endif
!
! --- REPERAGE DDL LAGRANGE DE CONTACT
!
    if (l_cont_cont .or. l_cont_lac) then
        sdnuco = sdnume(1:19)//'.NUCO'
        call jeveuo(sdnuco, 'L', jnuco)
    endif
!
! --- ACCES AUX CHAM_NO
!
    call jeveuo(cnfint(1:19)//'.VALE', 'L', vr=fint)
    call jeveuo(cndiri(1:19)//'.VALE', 'L', vr=diri)
    call jeveuo(cnfext(1:19)//'.VALE', 'L', vr=vfext)
    call jeveuo(ds_material%fvarc_curr(1:19)//'.VALE', 'L', vr=v_fvarc_curr)
!
    if (ldyna) then
        call jeveuo(foiner(1:19)//'.VALE', 'L', vr=iner)
    endif
!
! --- CALCUL DES RESIDUS
!
    do ieq = 1, neq
!
! ----- QUELLE REACTION D'APPUI ?
!
        appui = 0.d0
        fext = 0.d0
        if (lcine) then
            if (zi(jccid+ieq-1) .eq. 1) then
                appui = - fint(ieq)
                fext = 0.d0
            else
                appui = diri(ieq)
                fext = vfext(ieq)
            endif
        else
            appui = diri(ieq)
            fext = vfext(ieq)
        endif
!
        val2 = abs(appui-fext)+abs(v_fvarc_curr(ieq))
!
! ----- SI LAGRANGIEN DE CONTACT/FROT: ON IGNORE LA VALEUR DU RESIDU
!
        if (l_cont_cont .or. l_cont_lac) then
            if (zi(jnuco+ieq-1) .eq. 1) then
                goto 20
            endif
        endif
!
! ----- VCHAR: MAX CHARGEMENT EXTERIEUR EN STATIQUE
!
        if (vchar .le. val2) then
            vchar = val2
            ichar = ieq
        endif
!
! ----- VCHAR: MAX CHARGEMENT EXTERIEUR EN DYNAMIQUE
!
        if (ldyna) then
            val3 = abs(iner(ieq))
            if (vchar .le. val3) then
                vchar = val3
                ichar = ieq
            endif
        endif
!
 20     continue
    end do
!
    call jedema()
end subroutine
