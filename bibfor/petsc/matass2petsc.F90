subroutine matass2petsc(matasz, petscMatz, iret)
!
! COPYRIGHT (C) 1991 - 2018  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
! aslint: disable=C1308
! person_in_charge: natacha.bereux at edf.fr
!
#include "asterf_types.h"
#ifdef _HAVE_PETSC
#include "asterf_petsc.h"
#endif
use aster_petsc_module
use petsc_data_module
!
    implicit none
!
#include "asterf.h"
#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/apetsc.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/crsmsp.h"
#include "asterfort/jemarq.h"
#include "asterfort/detrsd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "blas/dcopy.h"
#ifndef _HAVE_PETSC
    integer :: petscMatz, iret
#endif
!
    character(len=*) :: matasz
!-----------------------------------------------------------------------
! BUT : ROUTINE D'INTERFACE ENTRE CODE_ASTER ET LA BIBLIOTHEQUE PETSC
!       DE RESOLUTION DE SYSTEMES LINEAIRES.
!
! IN  : MATASS   (K19) : NOM DE LA MATR_ASSE
!                       (SI ACTION=PRERES/RESOUD)
! OUT : petscMatz   (I) : MATRICE PETSC
! OUT : IRET       (I) : CODE_RETOUR
!-----------------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!----------------------------------------------------------------
!
!     VARIABLES LOCALES
    integer :: iprem, k, l, nglo, kdeb, jnequ, ierror
    integer ::  kptsc, ibid
    integer :: np
    real(kind=8) :: r8
!
    logical :: bool
    character(len=24), dimension(:), pointer :: slvk  => null()
    character(len=24), pointer :: refa(:) => null()
    character(len=19) :: solvbd, matas, vcine, kbid
    character(len=14) :: nu
    character(len=1) :: rouc
!
!----------------------------------------------------------------
!
!     Variables PETSc
    PetscErrorCode :: iret,ierr
    Mat :: petscMatz

    call jemarq()
!
    matas = matasz

!   -- Creation d'un solveur bidon
    solvbd='&&MAT2PET'
    call crsmsp(solvbd, matas, 50,'IN_CORE')
    call jeveuo(solvbd//'.SLVK', 'L', vk24=slvk)
    slvk(2)='SANS'

!   -- Conversion de matass vers petsc
    call apetsc('PRERES', solvbd, matas, [0.d0], ' ',&
                0, ibid, ierror )
    k = get_mat_id( matas )
    call MatDuplicate(ap(k), MAT_COPY_VALUES, petscMatz, ierr)
    ASSERT(ierr.eq.0)

!   -- Nettoyage
!   Destruction des objets petsc
    call apetsc('DETR_MAT', solvbd, matas, [0.d0], ' ',&
                0, ibid, ierror)
!   Destruction du solveur bidon
    call detrsd('SOLVEUR', solvbd)

999 continue
    call jedema()
#else
    call utmess('F', 'FERMETUR_10')
#endif
end subroutine
