/**
 *
 * write usecase
 */

abstract interface class BaseUseCase<T, Params >{

  Future<T> invoke(Params p);
}