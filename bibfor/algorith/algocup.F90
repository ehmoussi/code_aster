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

subroutine algocup(ds_contact, numedd, matass)
!
! person_in_charge: mickael.abbas at edf.fr
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/cucpem.h"
#include "asterfort/cucpes.h"
#include "asterfort/cucpma.h"
#include "asterfort/cudisd.h"
#include "asterfort/cudisi.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: matass
character(len=14) :: numedd
!
! ----------------------------------------------------------------------
!
! ROUTINE CONDITION UNILATERALES
! ALGORITHME DE PENALISATION (MATRICE NON SYMETRIQUE)
!
! ----------------------------------------------------------------------
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NUMEDD : NUME_DDL
! IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
!
    integer :: ifm, niv
    character(len=24) :: atmu
    integer :: jatmu, lmat
    integer :: nbliai, neq, nbliac
    character(len=19) :: matrcf
    character(len=24) :: coco
    integer :: nbliac_new, jcoco
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write(ifm,*) '<LIA_UNIL><> ALGO   : PENALISATION'
    endif
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    atmu = ds_contact%sdunil_solv(1:14)//'.ATMU'
    matrcf = ds_contact%sdunil_solv(1:14)//'.MATR'
    call jeveuo(atmu, 'E', jatmu)
!
! --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE GLOBALE
!
    call jeveuo(matass//'.&INT', 'E', lmat)
!
! --- INITIALISATION DES VARIABLES
!
    nbliai = cudisi(ds_contact%sdunil_defi(1:16),'NNOCU')
    neq = zi(lmat+2)
!
!   Mecanisle de stockage de nbliac
    nbliac = cudisd(ds_contact%sdunil_solv,'NBLIAC')
!
! --- CREATION DU SECOND MEMBRE AFMU = -E_N*AT*JEU
!
    call cucpes(ds_contact%sdunil_defi,&
                ds_contact%sdunil_solv,&
                jatmu, neq, nbliac_new)
!
    if (nbliac_new .eq. 0) then
        goto 999
    endif
!
! --- CALCUL DE LA MATRICE DE CONTACT PENALISEE ELEMENTAIRE [E_N*AT]
!
    call cucpem(ds_contact%sdunil_defi,&
                ds_contact%sdunil_solv, nbliai)
!
! --- CALCUL DE LA MATRICE DE CONTACT PENALISEE GLOBALE [E_N*AT*A]
!
    call cucpma(ds_contact%sdunil_defi,&
                ds_contact%sdunil_solv,&
                neq, nbliai, numedd, matrcf)
!
999  continue
!
!   Il faudra prevoir une actualisation de nbliac
!
! --- ACTUALISATION NOMBRE DE CONTRAINTES ACTIVES
!
    coco = ds_contact%sdunil_solv(1:14)//'.COCO'
    call jeveuo(coco, 'E', jcoco)
    zi(jcoco+3-1) = nbliac_new
!
    call jedema()
!
end subroutine
