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

subroutine mmconv(noma , ds_contact, valinc, solalg, vfrot,&
                  nfrot, vgeom     , ngeom, vpene)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/mmmcrf.h"
#include "asterfort/mmmcrg.h"
#include "asterfort/mmreas.h"
#include "asterfort/mreacg.h"
#include "asterfort/mm_pene_loop.h"
#include "asterfort/nmchex.h"
#include "asterfort/mmbouc.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: noma
    type(NL_DS_Contact), intent(inout) :: ds_contact
    character(len=19), intent(in) :: valinc(*)
    character(len=19), intent(in) :: solalg(*)
    real(kind=8), intent(out) :: vfrot
    character(len=16), intent(out) :: nfrot
    real(kind=8), intent(out) :: vgeom
    real(kind=8), intent(out) :: vpene
    character(len=16), intent(out) :: ngeom
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE)
!
! RESIDUS SPECIFIQUES POUR NEWTON GENERALISE
!
! ----------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! In  ds_contact       : datastructure for contact management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! OUT VFROT  : VALEUR NORME_MAX POUR RESI_FROT
! OUT NFROT  : LIEU OU VALEUR NORME_MAX POUR RESI_FROT
! OUT VGEOM  : VALEUR NORME_MAX POUR RESI_GEOM
! OUT NGEOM  : LIEU OU VALEUR NORME_MAX POUR RESI_GEOM
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: depplu, depmoi, ddepla,depdel
    aster_logical :: loop_cont_divec,loop_cont_diveg
    aster_logical :: lnewtf, lnewtg,lnewtc,l_exis_pena
    real(kind=8) :: time_curr

!
! ----------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
!
! --- INITIALISATIONS
!
    nfrot = ' '
    vfrot = r8vide()
    ngeom = ' '
    vgeom = r8vide()
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', depmoi)
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DEPDEL', depdel)
!
! --- FONCTIONNALITES ACTIVEES
!
    lnewtf = cfdisl(ds_contact%sdcont_defi,'FROT_NEWTON')
    lnewtg = cfdisl(ds_contact%sdcont_defi,'GEOM_NEWTON')
    lnewtc = cfdisl(ds_contact%sdcont_defi,'CONT_NEWTON')
    l_exis_pena       = cfdisl(ds_contact%sdcont_defi,'EXIS_PENA')
    time_curr = ds_contact%time_curr

!
! - Print
!
    if ((niv.ge.2) .and. (lnewtg.or.lnewtf)) then
        write (ifm,*) '<CONTACT> ... CALCUL DES RESIDUS POUR NEWTON GENERALISE'
    endif
!
! --- EVALUATION RESIDU SEUIL FROTTEMENT
!
    if (lnewtf) then
!
! ----- MISE A JOUR DES SEUILS
!
        call mmreas(noma, ds_contact, valinc)
!
! ----- CALCUL RESIDU DE FROTTEMENT
!
        call mmmcrf(noma, ddepla, depplu, nfrot, vfrot)
    endif
!
! --- EVALUATION RESIDU SEUIL GEOMETRIE
!
    if (lnewtg) then
!
! ----- MISE A JOUR DE LA GEOMETRIE
!
        call mreacg(noma, ds_contact)
!
! ----- CALCUL RESIDU DE GEOMETRIE
!
        call mmmcrg(noma, ddepla, depplu, ngeom, vgeom)
    endif
    
    if (l_exis_pena) then 
        call mm_pene_loop(ds_contact)
        vpene = ds_contact%calculated_penetration
        if (lnewtc) then
        !   Cas de newton generalise pour le contact
        !   Cas de point fixe pour la géométrie
        !   on remet a jour vpene a chaque iteration mais Pas de verif de conv pene
            if (.not. lnewtg) then 
                call mmbouc(ds_contact, 'Geom', 'Is_Divergence',loop_state_=loop_cont_diveg)
                if (loop_cont_diveg) then 
                    ds_contact%continue_pene = 4.0
                endif 
            else 
                ds_contact%continue_pene = 0.0            
            endif
        else 
        !   Cas de point fixe pour le contact
        !   on remet a jour vpene a chaque iteration mais Pas de verif de conv pene
            call mmbouc(ds_contact, 'Cont', 'Is_Divergence',loop_state_=loop_cont_divec)
            if (loop_cont_divec) then 
                ds_contact%continue_pene = 3.0
            else
                call mmbouc(ds_contact, 'Geom', 'Is_Divergence',loop_state_=loop_cont_diveg)
                if (loop_cont_diveg) then 
                    ds_contact%continue_pene = 4.0
                else 
                    ds_contact%continue_pene = 0.0
                endif                            
            endif
            
        endif
    endif


!
end subroutine
